import gleam/erlang/process
import gleam/io
import gleam/result
import gleam/dynamic
import sqlight
import wisp
import mist
import crud_contacts/database
import crud_contacts/errors
import crud_contacts/router
import crud_contacts/web

pub const db_name = "db.sqlite3"

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let assert Ok(_) = database.with_connection(db_name, database.migrate_schema)

  use db <- database.with_connection(db_name)

  let context = web.Context(db: db)

  let handler = router.handle_request(_, context)

  let assert Ok(_) =
    handler
    |> wisp.mist_handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn create_contact(db: sqlight.Connection) {
  let stmt =
    "
  INSERT INTO contacts (name, favourite_colour, birthday, phone_number, email)
  VALUES (?1, ?2, ?3, ?4, ?5)
  RETURNING id"
  use rows <- result.then(
    sqlight.query(
      stmt,
      on: db,
      with: [
        sqlight.text("Name"),
        sqlight.text("Blue"),
        sqlight.text("1990-05-15"),
        sqlight.text("027 251 8505"),
        sqlight.text("lia@lia.lol"),
      ],
      expecting: dynamic.element(0, dynamic.int),
    )
    |> result.map_error(fn(error) {
      case error.code, error.message {
        sqlight.ConstraintCheck, "CHECK constraint failed: empty_content" ->
          errors.ContentRequired
        sqlight.ConstraintForeignkey, _ -> errors.UserNotFound
        _, _ -> errors.BadRequest
      }
    }),
  )

  let assert [id] = rows
  Ok(id)
}
