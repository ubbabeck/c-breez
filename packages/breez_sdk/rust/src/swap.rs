use std::str::FromStr;
use std::sync::Arc;

use crate::binding::parse_invoice;
use crate::chain::{MempoolSpace, OnchainTx};
use crate::chain_notifier::{ChainEvent, Listener};
use crate::grpc::{AddFundInitRequest, GetSwapPaymentRequest};
use anyhow::{anyhow, Result};
use bitcoin::blockdata::opcodes;
use bitcoin::blockdata::script::Builder;
use bitcoin::psbt::serialize::Serialize;
use bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
use bitcoin::util::sighash::SighashCache;
use bitcoin::{
    Address, EcdsaSighashType, Network, OutPoint, Script, Sequence, Transaction, TxIn, TxOut, Txid,
    Witness,
};
use bitcoin_hashes::hex::FromHex;
use bitcoin_hashes::sha256;
use rand::Rng;
use ripemd::{Digest, Ripemd160};

use crate::models::{Swap, SwapInfo, SwapStatus, SwapperAPI};
use crate::node_service::{BreezServer, PaymentReceiver};

struct Utxo {
    out: OutPoint,
    value: u32,
    block_height: u32,
}

#[tonic::async_trait]
impl SwapperAPI for BreezServer {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_id: String,
    ) -> Result<Swap> {
        let mut fund_client = self.get_fund_manager_client().await?;
        let request = AddFundInitRequest {
            hash: hash.clone(),
            pubkey: payer_pubkey.clone(),
            node_id,
            notification_token: "".to_string(),
        };

        let result = fund_client.add_fund_init(request).await?.into_inner();
        Ok(Swap {
            bitcoin_address: result.address,
            swapper_pubkey: result.pubkey,
            lock_height: result.lock_height,
            max_allowed_deposit: result.max_allowed_deposit,
            error_message: result.error_message,
            required_reserve: result.required_reserve,
            min_allowed_deposit: result.min_allowed_deposit,
        })
    }

    async fn complete_swap(&self, bolt11: String) -> Result<()> {
        let request = GetSwapPaymentRequest {
            payment_request: bolt11,
        };
        self.get_fund_manager_client()
            .await?
            .get_swap_payment(request)
            .await?
            .into_inner();
        Ok(())
    }
}

pub struct BTCReceiveSwap {
    network: Network,
    swapper_api: Arc<dyn SwapperAPI>,
    persister: Arc<crate::persist::db::SqliteStorage>,
    chain_service: Arc<MempoolSpace>,
    payment_receiver: Arc<PaymentReceiver>,
}

#[tonic::async_trait]
impl Listener for BTCReceiveSwap {
    async fn on_event(&self, e: ChainEvent) -> Result<()> {
        match e {
            ChainEvent::NewBlock(tip) => {
                debug!("got chain event {:?}", e);
                let swaps = self.list_swaps().await?;
                let to_check: Vec<SwapInfo> = swaps
                    .into_iter()
                    .filter(|s| s.status == SwapStatus::Initial)
                    .collect();

                let mut redeemable_swaps: Vec<SwapInfo> = Vec::new();
                for s in to_check {
                    let address = s.bitcoin_address.clone();
                    let refresh_status = self
                        .refresh_swap_on_chain_status(address.clone(), tip)
                        .await;
                    match refresh_status {
                        Ok(updated) => {
                            debug!("status refreshed for address: {}", address.clone());
                            if updated.redeemable() {
                                redeemable_swaps.push(updated);
                            }
                        }
                        Err(e) => {
                            error!(
                                "failed to refresh status for address {}: {}",
                                address.clone(),
                                e
                            );
                        }
                    };
                }

                // redeem swaps
                for s in redeemable_swaps {
                    let redeem_res = self.redeem_swap(s.bitcoin_address.clone()).await;

                    if redeem_res.is_err() {
                        error!("failed to redeem swap {:?}: {}", e, s.bitcoin_address);
                    }
                }
            }
            _ => {} // skip events were are not interested in
        }

        Ok(())
    }
}

impl BTCReceiveSwap {
    pub(crate) fn new(
        network: Network,
        swapper_api: Arc<dyn SwapperAPI>,
        persister: Arc<crate::persist::db::SqliteStorage>,
        chain_service: Arc<MempoolSpace>,
        payment_receiver: Arc<PaymentReceiver>,
    ) -> Self {
        let swapper = Self {
            network,
            swapper_api,
            persister,
            chain_service,
            payment_receiver,
        };
        swapper
    }

    pub(crate) async fn create_swap_address(&self) -> Result<SwapInfo> {
        let node_state = self.persister.get_node_state()?;
        if node_state.is_none() {
            return Err(anyhow!("node is not initialized"));
        }
        let node_id = node_state.unwrap().id;
        // create swap keys
        let swap_keys = create_swap_keys()?;
        let secp = Secp256k1::new();
        let private_key = SecretKey::from_slice(&swap_keys.priv_key)?;
        let pubkey = PublicKey::from_secret_key(&secp, &private_key)
            .serialize()
            .to_vec();
        let hash = Message::from_hashed_data::<sha256::Hash>(&swap_keys.preimage[..])
            .as_ref()
            .to_vec();

        // use swap API to fetch a new swap address
        let swap_reply = self
            .swapper_api
            .create_swap(hash.clone(), pubkey.clone(), node_id)
            .await?;

        // calculate the submarine swap script
        let our_script = create_submarine_swap_script(
            hash.clone(),
            swap_reply.swapper_pubkey.clone(),
            pubkey.clone(),
            swap_reply.lock_height,
        )?;

        let address = bitcoin::Address::p2wsh(&our_script, self.network);
        let address_str = address.to_string();

        // Ensure our address generation match the service
        if address_str != swap_reply.bitcoin_address {
            return Err(anyhow!("wrong address"));
        }

        let swap_info = SwapInfo {
            bitcoin_address: swap_reply.bitcoin_address,
            created_at: 0,
            lock_height: swap_reply.lock_height,
            payment_hash: hash.clone(),
            preimage: swap_keys.preimage,
            private_key: swap_keys.priv_key.to_vec(),
            public_key: pubkey.clone(),
            swapper_public_key: swap_reply.swapper_pubkey.clone(),
            script: our_script.as_bytes().to_vec(),
            bolt11: None,
            paid_sats: 0,
            confirmed_sats: 0,
            status: SwapStatus::Initial,
        };

        // persist the address
        self.persister.insert_swap(swap_info.clone())?;
        Ok(swap_info)

        // return swap.bitcoinAddress;
    }

    pub(crate) async fn list_swaps(&self) -> Result<Vec<SwapInfo>> {
        self.persister.list_swaps()
    }

    async fn refresh_swap_on_chain_status(
        &self,
        bitcoin_address: String,
        current_tip: u32,
    ) -> Result<SwapInfo> {
        let swap_info = self
            .persister
            .get_swap_info(bitcoin_address.clone())?
            .ok_or_else(|| {
                anyhow!(format!(
                    "swap address {} was not found",
                    bitcoin_address.clone()
                ))
            })?;
        let txs = self
            .chain_service
            .address_transactions(bitcoin_address.clone())
            .await?;
        let utxos = get_utxos(bitcoin_address.clone(), txs)?;
        let confirmed_sats: u32 = utxos.iter().fold(0, |accum, item| accum + item.value);

        let confirmed_block = utxos.iter().fold(0, |b, item| {
            if item.block_height > b {
                item.block_height
            } else {
                b
            }
        });

        let mut swap_status = swap_info.status;
        if swap_status != SwapStatus::Refunded
            && current_tip - confirmed_block >= swap_info.lock_height as u32
        {
            swap_status = SwapStatus::Expired
        }
        self.persister
            .update_swap_chain_info(bitcoin_address, confirmed_sats, swap_status)
    }

    /// redeem_swap executes the final step of receiving lightning payment
    /// in exchange for the on chain funds.
    pub(crate) async fn redeem_swap(&self, bitcoin_address: String) -> Result<()> {
        let mut swap_info = self
            .persister
            .get_swap_info(bitcoin_address.clone())?
            .ok_or_else(|| anyhow!(format!("swap address {} was not found", bitcoin_address)))?;

        // we are creating and invoice for this swap if we didn't
        // do it already
        if swap_info.bolt11.is_none() {
            let invoice = self
                .payment_receiver
                .receive_payment(
                    swap_info.confirmed_sats as u64,
                    String::from("Bitcoin Transfer"),
                )
                .await?;
            self.persister
                .update_swap_bolt11(bitcoin_address.clone(), invoice.bolt11)?;
            swap_info = self
                .persister
                .get_swap_info(bitcoin_address.clone())?
                .unwrap();
        }

        // Making sure the invoice amount matches the on-chain amount
        let payreq = swap_info.bolt11.unwrap();
        let ln_invoice = parse_invoice(payreq.clone())?;
        if ln_invoice.amount_msat.unwrap() != (swap_info.confirmed_sats * 1000) as u64 {
            return Err(anyhow!("invoice amount doesn't match confirmed sats"));
        }

        // Asking the service to initiate the lightning payment
        let result = self.swapper_api.complete_swap(payreq.clone()).await;
        match result {
            Ok(r) => self
                .persister
                .update_swap_paid_amount(bitcoin_address, swap_info.confirmed_sats),
            Err(e) => Err(e),
        }
    }

    // refund_swap is the user way to receive on-chain refund for failed swaps.
    pub(crate) async fn refund_swap(
        &self,
        swap_address: String,
        to_address: String,
        sat_per_weight: u32,
    ) -> Result<String> {
        let swap_info = self
            .persister
            .get_swap_info(swap_address.clone())?
            .ok_or_else(|| anyhow!(format!("swap address {} was not found", swap_address)))?;

        let transactions = self
            .chain_service
            .address_transactions(swap_address.clone())
            .await?;
        let utxos = get_utxos(swap_address, transactions)?;

        let script = create_submarine_swap_script(
            swap_info.payment_hash,
            swap_info.swapper_public_key,
            swap_info.public_key,
            swap_info.lock_height,
        )?;
        let refund_tx = create_refund_tx(
            utxos,
            swap_info.private_key,
            to_address,
            swap_info.lock_height as u32,
            script,
            sat_per_weight,
        )?;
        let txid = self.chain_service.broadcast_transaction(refund_tx).await?;
        self.persister.update_swap_chain_info(
            swap_info.bitcoin_address,
            swap_info.confirmed_sats,
            SwapStatus::Refunded,
        )?;

        Ok(txid)
    }
}

struct SwapKeys {
    pub priv_key: Vec<u8>,
    pub preimage: Vec<u8>,
}

fn create_swap_keys() -> Result<SwapKeys> {
    let priv_key = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    let preimage = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    Ok(SwapKeys { priv_key, preimage })
}

fn create_submarine_swap_script(
    invoice_hash: Vec<u8>,
    swapper_pub_key: Vec<u8>,
    payer_pub_key: Vec<u8>,
    lock_height: i64,
) -> Result<Script> {
    let mut hasher = Ripemd160::new();
    hasher.update(invoice_hash);
    let result = hasher.finalize();

    Ok(Builder::new()
        .push_opcode(opcodes::all::OP_HASH160)
        .push_slice(&result[..])
        .push_opcode(opcodes::all::OP_EQUAL)
        .push_opcode(opcodes::all::OP_IF)
        .push_slice(&swapper_pub_key[..])
        .push_opcode(opcodes::all::OP_ELSE)
        .push_int(lock_height)
        .push_opcode(opcodes::all::OP_CSV)
        .push_opcode(opcodes::all::OP_DROP)
        .push_slice(&payer_pub_key[..])
        .push_opcode(opcodes::all::OP_ENDIF)
        .push_opcode(opcodes::all::OP_CHECKSIG)
        .into_script())
}

fn get_utxos(swap_address: String, transactions: Vec<OnchainTx>) -> Result<Vec<Utxo>> {
    // calcualte confirmed amount associated with this address
    let mut spent_outputs: Vec<OutPoint> = Vec::new();
    let mut utxos: Vec<Utxo> = Vec::new();
    for (_, tx) in transactions.iter().enumerate() {
        for (_, vin) in tx.vin.iter().enumerate() {
            if tx.status.confirmed && vin.prevout.scriptpubkey_address == swap_address.clone() {
                spent_outputs.push(OutPoint {
                    txid: Txid::from_hex(vin.txid.as_str())?,
                    vout: vin.vout,
                })
            }
        }
    }

    for (i, tx) in transactions.iter().enumerate() {
        for (index, vout) in tx.vout.iter().enumerate() {
            if tx.status.confirmed && vout.scriptpubkey_address == swap_address {
                let outpoint = OutPoint {
                    txid: Txid::from_hex(tx.txid.as_str())?,
                    vout: index as u32,
                };
                if !spent_outputs.contains(&outpoint) {
                    utxos.push(Utxo {
                        out: outpoint,
                        value: vout.value,
                        block_height: tx.status.block_height,
                    });
                }
            }
        }
    }
    Ok(utxos)
}

fn create_refund_tx(
    utxos: Vec<Utxo>,
    private_key: Vec<u8>,
    to_address: String,
    lock_delay: u32,
    input_script: Script,
    sat_per_weight: u32,
) -> Result<Vec<u8>> {
    if utxos.len() == 0 {
        return Err(anyhow!("must have at least one input"));
    }

    let lock_time = utxos.iter().fold(0, |accum, item| {
        if accum >= item.block_height + lock_delay {
            accum
        } else {
            item.block_height + lock_delay
        }
    });

    let confirmed_amount: u64 = utxos
        .iter()
        .fold(0, |accum, item| accum + item.value as u64);

    // create the tx inputs
    let txins: Vec<TxIn> = utxos
        .iter()
        .map(|utxo| TxIn {
            previous_output: utxo.out,
            script_sig: Script::new(),
            sequence: Sequence(lock_delay),
            witness: Witness::default(),
        })
        .collect();

    // create the tx outputs
    let btc_address = Address::from_str(&to_address)?;
    let mut tx_out: Vec<TxOut> = Vec::new();
    tx_out.push(TxOut {
        value: confirmed_amount,
        script_pubkey: btc_address.script_pubkey(),
    });

    // construct the transaction
    let mut tx = Transaction {
        version: 2,
        lock_time: bitcoin::PackedLockTime(lock_time),
        input: txins.clone(),
        output: tx_out,
    };

    let refund_witness_input_size: u32 = 1 + 1 + 73 + 1 + 0 + 1 + 100;
    let tx_size = tx.strippedsize() as u32 + refund_witness_input_size * txins.len() as u32;
    print!("tx size = {}", tx_size);
    let fees: u64 = (tx_size * sat_per_weight) as u64;
    tx.output[0].value = confirmed_amount - fees;

    let scpt = Secp256k1::signing_only();

    // go over all inputs and sign them
    let mut signed_inputs: Vec<TxIn> = Vec::new();
    for (index, input) in tx.input.iter().enumerate() {
        let mut signer = SighashCache::new(&tx);
        let sig = signer.segwit_signature_hash(
            index,
            &input_script,
            utxos[index].value as u64,
            bitcoin::EcdsaSighashType::All,
        )?;
        let msg = Message::from_slice(&sig[..])?;
        let secret_key = SecretKey::from_slice(private_key.as_slice())?;
        let sig = scpt.sign_ecdsa(&msg, &secret_key);

        let mut sigvec = sig.serialize_der().to_vec();
        sigvec.push(EcdsaSighashType::All as u8);

        let mut witness: Vec<Vec<u8>> = Vec::new();
        witness.push(sigvec);
        witness.push(vec![]);
        witness.push(input_script.serialize());

        let mut signed_input = input.clone();
        let w = Witness::from_vec(witness);
        signed_input.witness = w;
        signed_inputs.push(signed_input);
    }
    tx.input = signed_inputs;

    //tx.output[0].value = confirmed_amount;
    Ok(tx.serialize())
}

mod tests {
    use bitcoin::{
        secp256k1::{Message, PublicKey, Secp256k1, SecretKey},
        OutPoint, Txid,
    };
    use bitcoin_hashes::{hex::FromHex, sha256};
    use ripemd::{Digest, Ripemd160};

    use crate::{
        chain::{MempoolSpace, OnchainTx},
        swap::{BTCReceiveSwap, Utxo},
        test_utils::{create_test_config, create_test_persister, MockSwapperAPI},
    };

    use super::{create_refund_tx, create_submarine_swap_script, create_swap_keys, get_utxos};

    #[test]
    fn test_build_swap_script() {
        // swap payer private/public key pair
        // swap payer public key
        let secp = Secp256k1::new();
        let private_key = SecretKey::from_slice(
            &hex::decode("1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330")
                .unwrap(),
        )
        .unwrap();
        let pub_key = PublicKey::from_secret_key(&secp, &private_key)
            .serialize()
            .to_vec();

        // Another pair for preimage/hash
        let preimage =
            hex::decode("4bedf04d0e1ed625e8863163e26abe4e1e6e3e9e5a25fa28cf4fe89500aadd46")
                .unwrap();
        let hash = Message::from_hashed_data::<sha256::Hash>(&preimage.clone()[..])
            .as_ref()
            .to_vec();

        // refund lock height
        let lock_height = 288;

        // swapper pubkey
        let swapper_pubkey =
            hex::decode("02b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe88")
                .unwrap();

        let expected_address = "bc1qwxgj02vc9esa32ylkrqnhmvcamwtd95wndxqpdwk4mh9pj4629uqcjwv8l";

        // create the script
        let script =
            create_submarine_swap_script(hash, swapper_pubkey, pub_key, lock_height).unwrap();

        // compare the expected and created script
        let expected_script = "a91458163502b02967cfb7c0f3859874db702121b5d487632102b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe8867022001b27521024ad3b16767cf68d59c41b9544e42340959479447a82a5cd24c320e1ce92adb0968ac".to_string();
        let serialized_script = hex::encode(script.as_bytes().to_vec());
        assert_eq!(expected_script, serialized_script);

        // compare the expected and created swap address
        let address = bitcoin::Address::p2wsh(&script, bitcoin::Network::Bitcoin);
        let address_str = address.to_string();
        assert_eq!(address_str, expected_address);
    }

    #[tokio::test]
    async fn test_get_utxo() {
        let swap_address = String::from("35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3");
        let txs: Vec<OnchainTx> = serde_json::from_str(r#"[{"txid":"5e0668bf1cd24f2f8656ee82d4886f5303a06b26838e24b7db73afc59e228985","version":2,"locktime":0,"vin":[{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","vout":0,"prevout":{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},"scriptsig":"","scriptsig_asm":"","witness":["3045022100a2f0ac810ce88625890f7e212d175eb1cd6b7c73ffed95a2bec06b38e0b2de060220036675c6a5c89845988cc27e7acba772e7655f2abb0575449471d8323d5900b301","026b815dddaf1687a05349d75d25911c9b6e2381e55ba72148009cfa0a577c89d9"],"is_coinbase":false,"sequence":0},{"txid":"6d6766c283093e2d043ae877bb915175b3d8672a20f0459300267aaab1b5766a","vout":0,"prevout":{"scriptpubkey":"001485b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 85b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qskencxfhqk8dpz6mzghrpjh33enuev5zh0mrjw","value":33247},"scriptsig":"","scriptsig_asm":"","witness":["304402200272cac1a312aae2a4ee64150e5b26e611a56509a467176e38c905b632d3ce56022005497d0d3ff14911214cb0fbb22a1aa16830ba669f6ff38723684750ceb4b11a01","0397d3b72557bd2044508ee3b22d1216b3f871c0963500f8c8dc6a143ee7a6a206"],"is_coinbase":false,"sequence":0},{"txid":"81af33ae00a9dadeb83b915b05742e986a470fff7456540e3f018deb94abda0e","vout":1,"prevout":{"scriptpubkey":"001431505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 31505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qx9g9v3cfydr6hv8y62357emnka9fn8294e73yl","value":172952},"scriptsig":"","scriptsig_asm":"","witness":["30450221008426c1b3d535f10c7cbccec6be3ea9be3514f3a86bf234584722665325283f35022010b6a617a465d1d7eea45562632f0ab80b0894da44b67fab65191a98fd9d3acb01","0221250914423379d3caf662297e8069621ca2c362cf92107388483929f4d9eb67"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001459c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 59c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt8rscz0j9vdmqp6rnt6rk6qf663tcvd44f6gxa","value":2920},{"scriptpubkey":"00202c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 2c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1q93qyum5uf5pjyeaznfs8f3wmjveudn9wpjw5xr8dve33vgea3shs9jhvww","value":442557}],"size":532,"weight":1153,"fee":23938,"status":{"confirmed":true,"block_height":674358,"block_hash":"00000000000000000004c6171622f56692cc480d3c76ecae4355e69699a6ae44","block_time":1615595727}},{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","version":2,"locktime":0,"vin":[{"txid":"9332d8d11d81c3b674caff75db5543491e7f22e619ecc034bedf4a007518fe3a","vout":0,"prevout":{"scriptpubkey":"001415f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 15f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qzhcd446gq6crvyngwqudfad6kgq2lnuw9r2a86","value":470675},"scriptsig":"","scriptsig_asm":"","witness":["3045022100f30d84532f96b5e489047174e81394883cd519d427ca8f4facc2366f718cc678022007c083634402f40708c645cd0c1a2757b56de2076ca6ee856e514859381cd93801","02942b44eb4289e3af0aeeb73dfa82b0a5c8a3a06ae85bfd22aa3dcfcd64096462"],"is_coinbase":false,"sequence":0},{"txid":"c62da0c2d1929ab2a2c04d4fbae2a6e4e947f867cba584d1f80c4a1a62f4a75f","vout":1,"prevout":{"scriptpubkey":"0014f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7rqaddr36hj2fqluz3k5yg9yaq2c00c3tw4qy5","value":899778},"scriptsig":"","scriptsig_asm":"","witness":["304402202da0eac25786003181526c4fe1592f982aa8d0f32c642a5103cdebbf4aa8b5a80220750cd6859bfb9a7df8d7c4d79a70e17a6df87f150fe1fdaade4650332ef0f47c01","02ecab80fcfe949633064c25fc33854fd09b8730decdf679db1f429bce201ec685"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},{"scriptpubkey":"00200cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 0cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1qpn4xpt57afp7vjchhfj6fstm6wk0nkkrq7p9mmdgt4dqjvvpm0qqlxqrns","value":1088924}],"size":383,"weight":881,"fee":18313,"status":{"confirmed":true,"block_height":674357,"block_hash":"00000000000000000008d0d007995a8bc9d60de17bd6b55e28a6e4c6918cb206","block_time":1615594996}}]"#).unwrap();
        let utxos = get_utxos(swap_address.clone(), txs).unwrap();
        assert_eq!(utxos.len(), 0);

        let swap_address = String::from("35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3");
        let txs: Vec<OnchainTx> = serde_json::from_str(r#"[{"txid":"9f13dd16167430c2ccb3b89b5f915a3c836722c486e30505791c9604f1017a99","version":1,"locktime":0,"vin":[{"txid":"3d8e3b3e7ad5a396902f8814a5446139dd55757c6f3fa5fc63e905f1fef00a10","vout":66,"prevout":{"scriptpubkey":"a914b0f4345fad758790048c03d46fccf66b852ec9e387","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b0f4345fad758790048c03d46fccf66b852ec9e3 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3HpfPwMTCggpmwMNxebnJB6y8jJP8Y3mdM","value":8832100},"scriptsig":"160014716588545d5a9ddcc2e38802d7382b8fc37e90ba","scriptsig_asm":"OP_PUSHBYTES_22 0014716588545d5a9ddcc2e38802d7382b8fc37e90ba","witness":["30450221008d73700314bd2de9e56256ce0548fe08f220f5c928075a242ca9a7980b0e7f5602202701318e9a6c3ba128dcf915c6c3997928e9870d4023150e6bfb84a783617a1c01","025dddb140932a1247c1cdc2dec534ba2a7647bb03c989a88e6d18117517f388f3"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 716588545d5a9ddcc2e38802d7382b8fc37e90ba"},{"txid":"9e64ea8118b13871d02d941552fa42af6d079e4e9384aa71a7da747d52cb468b","vout":0,"prevout":{"scriptpubkey":"a914b7969fec4adfad203881f98b6c04dfeeff774f5487","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b7969fec4adfad203881f98b6c04dfeeff774f54 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3JRk2EfAr1mjYmXSMf5heBRnA6ym7WFsX1","value":23093207},"scriptsig":"160014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","scriptsig_asm":"OP_PUSHBYTES_22 0014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","witness":["30440220368b9584a2837542b600bbce16293811b01d0c5f919d153eb0d6c6716c4357000220379b6f91cb24c3d8193e39acaed2dbb973084bff10aff48059a1086672c5cde401","02074b5af43b526fedea5527edf1d246d1821867f161ebd9ca26295e21aeddb30a"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d"}],"vout":[{"scriptpubkey":"a9142c85a9b818d3cdf89bd3a1057bb21b2c7e64ad6087","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 2c85a9b818d3cdf89bd3a1057bb21b2c7e64ad60 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3","value":31461100}],"size":387,"weight":897,"fee":464207,"status":{"confirmed":true,"block_height":764153,"block_hash":"00000000000000000000199349a95526c4f83959f0ef06697048a297f25e7fac","block_time":1669044812}}]"#).unwrap();
        let utxos = get_utxos(swap_address.clone(), txs).unwrap();
        assert_eq!(utxos.len(), 1);
    }

    #[test]
    fn test_refund() {
        // test parameters
        let payer_priv_key_raw = [1; 32].to_vec();
        let swapper_priv_key_raw = [2; 32].to_vec();
        let preimage: [u8; 32] = [3; 32];
        let to_address = String::from("bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2");
        let lock_time = 288;

        let utxos: Vec<Utxo> = vec![Utxo {
            out: OutPoint {
                txid: Txid::from_hex(
                    "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                )
                .unwrap(),
                vout: 0,
            },
            value: 20000,
            block_height: 700000,
        }];

        // payer keys
        let secp = Secp256k1::new();
        let payer_private_key = SecretKey::from_slice(&payer_priv_key_raw).unwrap();
        let payer_pub_key = PublicKey::from_secret_key(&secp, &payer_private_key)
            .serialize()
            .to_vec();

        // swapper keys
        let swapper_private_key = SecretKey::from_slice(&swapper_priv_key_raw).unwrap();
        let swapper_pub_key = PublicKey::from_secret_key(&secp, &swapper_private_key)
            .serialize()
            .to_vec();

        // calculate payment hash
        let payment_hash = Message::from_hashed_data::<sha256::Hash>(&preimage.clone()[..])
            .as_ref()
            .to_vec();

        let script =
            create_submarine_swap_script(payment_hash, swapper_pub_key, payer_pub_key, lock_time)
                .unwrap();

        let refund_tx = create_refund_tx(
            utxos,
            payer_priv_key_raw,
            to_address,
            lock_time as u32,
            script,
            0,
        )
        .unwrap();

        /*  We test that the refund transaction looks like this
           {
            "addresses": [
                "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
            ],
            "block_height": -1,
            "block_index": -1,
            "confirmations": 0,
            "double_spend": false,
            "fees": 0,
            "hash": "3f9cf5bef98a0ed82c0ef8e4bd34e3624bbedf60b4cbaae3b1180569d562f2fb",
            "inputs": [
                {
                    "age": 0,
                    "output_index": 0,
                    "prev_hash": "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                    "script_type": "empty",
                    "sequence": 288
                }
            ],
            "lock_time": 700288,
            "opt_in_rbf": true,
            "outputs": [
                {
                    "addresses": [
                        "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
                    ],
                    "script": "001465c96c830168b8f0b584294d3b9716bb8584c2d8",
                    "script_type": "pay-to-witness-pubkey-hash",
                    "value": 20000
                }
            ],
            "preference": "low",
            "received": "2022-11-16T10:24:20.100655728Z",
            "relayed_by": "3.235.183.11",
            "size": 157,
            "total": 20000,
            "ver": 2,
            "vin_sz": 1,
            "vout_sz": 1,
            "vsize": 101
        }
        */
        assert_eq!(hex::encode(refund_tx), "0200000000010130037fa97f58d7f685ce861f7862112d8377364c4898f1d63213ff949ffeb31a00000000002001000001204e00000000000016001465c96c830168b8f0b584294d3b9716bb8584c2d80347304402203285efcf44640551a56c53bde677988964ef1b4d11182d5d6634096042c320120220227b625f7827993aca5b9d2f4690c5e5fae44d8d42fdd5f3778ba21df8ba7c7b010064a9148a486ff2e31d6158bf39e2608864d63fefd09d5b876321024d4b6cd1361032ca9bd2aeb9d900aa4d45d9ead80ac9423374c451a7254d076667022001b27521031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f68ac80af0a00");
    }
}
