use std::sync::{Arc, Mutex};

use dao::Database;

pub mod controller;
pub mod config;
pub mod dao;


pub struct  AppState<'a>{
    pub connection: Mutex<u32>,
    pub context: Arc<Database<'a>>,
}


