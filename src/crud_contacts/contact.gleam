import gleam/dynamic
import gleam/result
import gleam/list
import gleam/io
import sqlight
import wisp
import crud_contacts/web.{type Context}
import crud_contacts/errors.{type AppError}

pub type Contact {
  Contact(
    id: Int,
    name: String,
    favourite_colour: String,
    phone: String,
    email: String,
    created: String,
    updated: String,
  )
}

pub type FormData {
  FormData(name: String, fav_colour: String, phone: String, email: String)
}

pub type FormError {
  MissingRequiredField
}

pub fn decode_contact() -> dynamic.Decoder(Contact) {
  dynamic.decode7(
    Contact,
    dynamic.element(0, dynamic.int),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
    dynamic.element(3, dynamic.string),
    dynamic.element(4, dynamic.string),
    dynamic.element(5, dynamic.string),
    dynamic.element(6, dynamic.string),
  )
}

pub fn list(ctx: Context) -> List(Contact) {
  let stmt =
    "SELECT id, name, favourite_colour, phone, email, created, updated
    FROM contacts
    ORDER BY
    name ASC"

  let assert Ok(rows) =
    sqlight.query(stmt, on: ctx.db, with: [], expecting: decode_contact())

  rows
}

pub fn new(formdata: FormData, ctx: Context) -> Result(Int, AppError) {
  let stmt =
    "INSERT INTO contacts (name, favourite_colour, phone, email)
    VALUES (?1, ?2, ?3, ?4)
    RETURNING id"

  // let name = "lia"
  // let favourite_colour = "Blue"
  // let phone = "0272518505"
  // let email = "lia@example.com"

  use rows <- result.then(
    sqlight.query(
      stmt,
      on: ctx.db,
      with: [
        sqlight.text(formdata.name),
        sqlight.text(formdata.fav_colour),
        sqlight.text(formdata.phone),
        sqlight.text(formdata.email),
      ],
      expecting: dynamic.element(0, dynamic.int),
    )
    |> result.map_error(fn(error) {
      case error.code, error.message {
        sqlight.ConstraintCheck, "CHECK constraint failed: empty_content" ->
          errors.ContentRequired
        sqlight.ConstraintForeignkey, _ -> errors.UserNotFound
        _, _ -> {
          io.debug(error.message)
          errors.BadRequest
        }
      }
    }),
  )

  let assert [id] = rows
  io.debug(id)
  Ok(id)
}
