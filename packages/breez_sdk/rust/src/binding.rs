use std::sync::Mutex;

use anyhow::{anyhow, Result};
use once_cell::sync::Lazy;

use crate::{greenlight::Greenlight, node_service::NodeService};
use crate::models::{Config, GreenlightCredentials, LightningTransaction, Network, NodeAPI, PaymentTypeFilter};
use crate::node_service::{BreezLSP, NodeServiceBuilder};
use crate::test_utils::MockNodeAPI;

static STATE: Lazy<Mutex<Option<Greenlight>>> = Lazy::new(|| Mutex::new(None));

pub async fn register_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    Greenlight::register(network, seed).await
}

pub async fn recover_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    Greenlight::recover(network, seed).await
}

pub async fn create_node_services(
    network: Network,
    seed: Vec<u8>,
    creds: GreenlightCredentials,
) -> Result<NodeService> {
    let greenlight = Greenlight::new(network, seed, creds).await?;
    *STATE.lock().unwrap() = Some(greenlight);
    build_services().await
}

pub async fn start_node() -> Result<()> {
    build_services().await?.start_node().await
}

pub async fn run_signer() -> Result<()> {
    build_services().await?.run_signer().await
}

pub async fn sync() -> Result<()> {
    build_services().await?.sync().await
}

pub async fn list_transactions(
    filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> Result<Vec<LightningTransaction>> {
    build_services()
        .await?
        .list_transactions(filter, from_timestamp, to_timestamp)
        .await
}

async fn build_services() -> Result<NodeService> {
    let g = STATE.lock().unwrap().clone();
    let greenlight = g
        .ok_or("greenlight is not initialized")
        .map_err(|e| anyhow!(e))?;

    Ok(NodeServiceBuilder::default()
        .config(Config::default())
        .client(Box::new(greenlight))
        .client_grpc_init_from_config().await
        .build().await
    )
}
