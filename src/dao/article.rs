use std::usize;

use chrono::{DateTime, NaiveDateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{mysql::MySqlRow, FromRow, Row};
use tracing::info;

use super::Table;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Article {
    id: Option<String>,
    title: Option<String>,
    content: Option<String>,
    user_id: Option<String>,
    target: Option<Vec<String>>,
    created_at: Option<String>,
    update_at: Option<String>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct ArticleArraryRequest{
    id: Option<String>,
    title: Option<String>,
}

impl<'c> Table<'c, Article> {

     pub async fn select_blog_by_id(&self, id: String) -> Result<Article, sqlx::Error> {
        info!("select article from id: {}", id);
        let temp = sqlx::query_as(
            r#"
                SELECT * 
                FROM blog_article
                WHERE id = ?
                "#,
        )
        .bind(id)
        .fetch_one(&*self.pool)
        .await;

        temp
    }
}
impl<'c> Table<'c, ArticleArraryRequest> {
     pub async fn select_blog_arrary_by_user_id(&self, user_id: String) -> Result<Vec<ArticleArraryRequest>, sqlx::Error> {
        info!("select article from user_id: {}", user_id);
        let temp = sqlx::query_as(
            r#"
                SELECT id, title 
                FROM blog_article
                WHERE user_id = ?
                "#,
        )
        .bind(user_id)
        .fetch_all(&*self.pool)
        .await;

        temp
    }
}

impl<'c> FromRow<'c, MySqlRow> for Article {
    fn from_row(row: &'c MySqlRow) -> Result<Self, sqlx::Error> {
        let target: String= row.get::<String, usize>(4);
        let temp = target.split(",").map(|v| v.to_string()).collect();


        Ok(Article {
            id: row.get(0),
            title: row.get(1),
            content: row.get(2),
            user_id: row.get(3),
            target: Some(temp),
            created_at: row.get(5),
            update_at: row.get(6),
        })
    }
}

impl<'c> FromRow<'c, MySqlRow> for ArticleArraryRequest{
    fn from_row(row: &'c MySqlRow) -> Result<Self, sqlx::Error> {


        Ok(ArticleArraryRequest {
            id: row.get(0),
            title: row.get(1),
        })
    }
}

