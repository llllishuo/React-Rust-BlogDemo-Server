use serde::{Deserialize, Serialize};
use sqlx::{mysql::MySqlRow, FromRow, Row};
use tracing::info;

use super::Table;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct User {
    pub id: Option<String>,
    pub name: Option<String>,
    pub username: Option<String>,
    pub email: Option<String>,
    pub password: Option<String>,
    pub bio: Option<String>,
    pub is_login: Option<String>,
}

impl<'c> FromRow<'c, MySqlRow> for User {
    fn from_row(row: &MySqlRow) -> Result<Self, sqlx::Error> {
        Ok(User {
            id: row.get(0),
            name: row.get(1),
            username: row.get(2),
            email: row.get(3),
            password: row.get(4),
            bio: row.get(5),
            is_login:row.get(6),
        })
    }
}

impl<'c> Table<'c, User> {
    pub async fn select_user_by_id(&self, id: String) -> Result<User, sqlx::Error> {
        info!("select user from id: {}", id);
        let temp = sqlx::query_as(
            r#"
                SELECT * 
                FROM blog_user
                WHERE id = ?
                "#,
        )
        .bind(id)
        .fetch_one(&*self.pool)
        .await;

        temp
    }
}
