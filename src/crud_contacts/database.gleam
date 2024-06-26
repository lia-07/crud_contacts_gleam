import gleam/result
import sqlight
import crud_contacts/errors.{type AppError}

pub fn with_connection(name: String, func: fn(sqlight.Connection) -> a) -> a {
  use db <- sqlight.with_connection(name)

  func(db)
}

pub fn migrate_schema(db: sqlight.Connection) -> Result(Nil, AppError) {
  sqlight.exec(
    "CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK(length(name) > 0),
    favourite_colour TEXT,
    phone TEXT,
    email TEXT,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );",
    db,
  )
  |> result.map_error(errors.SqlightError)
}
