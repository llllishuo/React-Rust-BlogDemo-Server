use actix_web::{
    get, web::{self, Data, Path}, HttpResponse, Responder
};
use tracing::info;

use crate::AppState;

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(get_article);
    cfg.service(get_article_list_by_user_id);
}

#[get("/article/list/{user_id}")]
async fn get_article_list_by_user_id(user_id: Path<String>, app_state: Data<AppState<'_>>) -> impl Responder {
    info!("GET: /article/list/{}", user_id);
    let blog = app_state
        .context
        .articlesArrary
        .select_blog_arrary_by_user_id(user_id.to_string())
        .await;
    info!("{:?}", blog);

    match blog {
        Err(_) => HttpResponse::NotFound().finish(),
        Ok(v) => HttpResponse::Ok().json(v),
    }
}
#[get("/article/{id}")]
async fn get_article(id: Path<String>, app_state: Data<AppState<'_>>) -> impl Responder {
    info!("GET: /article/{}", id);
    let blog = app_state
        .context
        .articles
        .select_blog_by_id(id.to_string())
        .await;
    info!("{:?}", blog);

    match blog {
        Err(_) => HttpResponse::NotFound().finish(),
        Ok(v) => HttpResponse::Ok().json(v),
    }
}
