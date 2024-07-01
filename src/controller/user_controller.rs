use actix_web::{
    get,
    web::{self, Data, Path},
    HttpResponse, Responder,
};
use tracing::info;

use crate::AppState;

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(get_user);
}

#[get("/user/{id}")]
async fn get_user(id: Path<String>, app_state: Data<AppState<'_>>) -> impl Responder {
    info!("GET: /user/{}", id);
    let user = app_state.context.users.select_user_by_id(id.to_string()).await;
    info!("user: {:?}", user);

    match user {
        Err(_) => HttpResponse::NotFound().finish(),
        Ok(mut u) => HttpResponse::Ok().json(u),
    }
}
