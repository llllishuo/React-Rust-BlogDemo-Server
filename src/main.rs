use std::sync::{Arc, Mutex};

use actix_app_blog::{config::Config, controller, dao::Database, AppState};
use actix_web::{web, App, HttpResponse, HttpServer};
use tracing::info;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    
    tracing_subscriber::fmt::init();        
    
    let config = Config::create();
    info!("create config ...");

    let db = Database::new(config.database()).await;
    info!("create database ...");

    let app_state = web::Data::new(AppState{
        connection: Mutex::new(0),
        context: Arc::new(db),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .configure(controller::init_user_controller)
            .configure(controller::init_article_controller)
    })
    .bind(config.app())?
    .run()
    .await

}
