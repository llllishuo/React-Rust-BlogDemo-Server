use std::fs;

use serde::Deserialize;

#[derive(Deserialize)]
struct AppConfig {
    url: String,
    port: u16,
}

#[derive(Deserialize)]
struct DaoConfig {
    user: String,
    password: String,
    address: String,
    database: String,
}

#[derive(Deserialize)]
pub struct Config {
    app: AppConfig,
    dao: DaoConfig,
}

impl Config {
    pub fn create() -> Self {
        let config = fs::read_to_string("config.json").unwrap();
        serde_json::from_str(&config).unwrap()
    }

    pub fn app(&self) -> String {
        format!("{}:{}", self.app.url, self.app.port)
    }
    pub fn database(&self) -> String{
        format!(
            "mysql://{}:{}@{}/{}",
            self.dao.user, self.dao.password, self.dao.address, self.dao.database
        )
    }
}
