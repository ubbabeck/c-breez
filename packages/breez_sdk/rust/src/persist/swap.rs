use crate::models::{Swap, SwapInfo, SwapStatus};

use super::db::SqliteStorage;
use anyhow::{anyhow, Result};
use rusqlite::{named_params, OptionalExtension};

impl SqliteStorage {
    pub fn insert_swap_info(&self, swap_info: SwapInfo) -> Result<()> {
        self.get_connection()?.execute(
         "INSERT INTO swaps (bitcoin_address, created_at, lock_height, payment_hash, preimage, private_key, public_key, swapper_public_key, paid_sats, confirmed_sats, script, status)
          VALUES (:bitcoin_address, :created_at, :lock_height, :payment_hash, :preimage, :private_key, :public_key, :swapper_public_key, :paid_sats, :confirmed_sats, :script, :status)",
         named_params! {
             ":bitcoin_address": swap_info.bitcoin_address,
             ":created_at": swap_info.created_at,
             ":lock_height": swap_info.lock_height,
             ":payment_hash": swap_info.payment_hash,
             ":preimage": swap_info.preimage,
             ":private_key": swap_info.private_key,
             ":public_key": swap_info.public_key,
             ":swapper_public_key": swap_info.swapper_public_key,
             ":paid_sats": swap_info.paid_sats,
             ":confirmed_sats": swap_info.confirmed_sat,
             ":script": swap_info.script,
             ":status": swap_info.status as u32,
         },
        )?;

        Ok(())
    }

    pub fn get_swap_info(&self, address: String) -> Result<Option<SwapInfo>> {
        self.get_connection()?
            .query_row(
                "SELECT * FROM swaps where bitcoin_address= ?1",
                [address],
                |row| {
                    let status: i32 = row.get(11)?;
                    let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                    Ok(SwapInfo {
                        bitcoin_address: row.get(0)?,
                        created_at: row.get(1)?,
                        lock_height: row.get(2)?,
                        payment_hash: row.get(3)?,
                        preimage: row.get(4)?,
                        private_key: row.get(5)?,
                        public_key: row.get(6)?,
                        swapper_public_key: row.get(7)?,
                        paid_sats: row.get(8)?,
                        confirmed_sat: row.get(9)?,
                        script: row.get(10)?,
                        status: status,
                    })
                },
            )
            .optional()
            .map_err(|e| anyhow!(e))
    }

    pub fn list_swaps(&self) -> Result<Vec<SwapInfo>> {
        let con = self.get_connection()?;
        let mut stmt = con.prepare(
            format!(
                "
              SELECT * FROM swaps            
             "
            )
            .as_str(),
        )?;
        let vec: Vec<SwapInfo> = stmt
            .query_map([], |row| {
                let status: i32 = row.get(11)?;
                let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                Ok(SwapInfo {
                    bitcoin_address: row.get(0)?,
                    created_at: row.get(1)?,
                    lock_height: row.get(2)?,
                    payment_hash: row.get(3)?,
                    preimage: row.get(4)?,
                    private_key: row.get(5)?,
                    public_key: row.get(6)?,
                    swapper_public_key: row.get(7)?,
                    paid_sats: row.get(8)?,
                    confirmed_sat: row.get(9)?,
                    script: row.get(10)?,
                    status: status,
                })
            })?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }
}

#[test]
fn test_swaps() -> Result<(), Box<dyn std::error::Error>> {
    use crate::persist::test_utils;

    let storage = SqliteStorage::from_file(test_utils::create_test_sql_file("swap".to_string()));

    storage.init()?;
    let tested_swap_info = SwapInfo {
        bitcoin_address: String::from("1"),
        created_at: 0,
        lock_height: 100,
        payment_hash: vec![1],
        preimage: vec![2],
        private_key: vec![3],
        public_key: vec![4],
        swapper_public_key: vec![5],
        paid_sats: 100,
        confirmed_sat: 100,
        script: vec![5],
        status: crate::models::SwapStatus::Confirmed,
    };
    storage.insert_swap_info(tested_swap_info.clone())?;
    let item_value = storage.get_swap_info("1".to_string())?.unwrap();
    assert_eq!(item_value, tested_swap_info);

    let non_existent_swap = storage.get_swap_info("non-existent".to_string())?;
    assert!(non_existent_swap.is_none());

    let swaps = storage.list_swaps()?;
    assert_eq!(swaps.len(), 1);

    let err = storage.insert_swap_info(tested_swap_info.clone());
    //assert_eq!(swaps.len(), 1);
    assert!(err.is_err());

    Ok(())
}
