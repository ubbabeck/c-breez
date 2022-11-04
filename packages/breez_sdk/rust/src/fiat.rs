use crate::grpc::RatesRequest;
use crate::models::FiatAPI;
use crate::node_service::BreezServer;
use anyhow::Result;
use serde::{Deserialize, Serialize};
use tonic::Request;

#[derive(Serialize, Deserialize, Debug)]
struct Symbol {
    grapheme: Option<String>,
    template: Option<String>,
    rtl: Option<bool>,
    position: Option<u32>,
}

#[derive(Serialize, Deserialize, Debug)]
struct LocaleOverrides {
    spacing: Option<u32>,
    symbol: Symbol,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct FiatCurrency {
    name: String,
    fraction_size: u32,
    spacing: Option<u32>,
    symbol: Option<Symbol>,
    uniq_symbol: Option<Symbol>,
    localized_name: Option<Vec<(String, String)>>,
    locale_overrides: Option<Vec<(String, LocaleOverrides)>>,
}
#[tonic::async_trait]
impl FiatAPI for BreezServer {
    // retrieve all available fiat currencies from a local configuration file
    fn list_fiat_currencies() -> Result<Vec<(String, FiatCurrency)>> {
        let data = include_str!("../assets/json/currencies.json");
        Ok(serde_json::from_str(&data).unwrap())
    }

    // get the live rates from the server
    async fn fetch_rates(&self) -> Result<Vec<(String, f64)>> {
        let mut client = self.get_information_client().await?;

        let request = Request::new(RatesRequest {});
        let response = client.rates(request).await?;
        Ok(response
            .into_inner()
            .rates
            .into_iter()
            .map(|r| (r.coin, r.value))
            .collect())
    }
}
