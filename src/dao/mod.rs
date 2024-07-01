use std::{marker::PhantomData, sync::Arc};

use article::{Article, ArticleArraryRequest};
use sqlx::{mysql::MySqlRow, FromRow, MySqlPool};
use tracing::info;
use user::User;

pub mod article;
pub mod user;

pub struct Table<'c, T>
where
    T: FromRow<'c, MySqlRow>,
{
    pub pool: Arc<MySqlPool>,
    _marker: PhantomData<&'c T>,
}
impl<'c, T> Table<'c, T>
where
    T: FromRow<'c, MySqlRow>,
{
    pub fn new(pool: Arc<MySqlPool>) -> Self {
        Self {
            pool,
            _marker: PhantomData,
        }
    }
}

pub struct Database<'b> {
    pub users: Arc<Table<'b, User>>,
    pub articles: Arc<Table<'b, Article>>,
    pub articlesArrary: Arc<Table<'b, ArticleArraryRequest>>,
}
impl<'b> Database<'b> {
    pub async fn new(url: String) -> Database<'b> {
        let connection = MySqlPool::connect(url.as_str()).await.unwrap();
        let pool = Arc::new(connection);
        Self {
            users:Arc::from(Table::new(pool.clone())),
            articles: Arc::from(Table::new(pool.clone())),
            articlesArrary: Arc::from(Table::new(pool.clone())),
        }
    }
}
