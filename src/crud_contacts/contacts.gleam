import gleam/dynamic
import gleam/io
import gleam/string_builder
import gleam/http.{Get, Post}
import sqlight
import wisp.{type Request, type Response}
import crud_contacts/web.{type Context}
import crud_contacts/template

pub type PartialContact {
  PartialContact(id: Int, name: String, phone_number: String, email: String)
}

pub type FullContact {
  FullContact(
    id: Int,
    name: String,
    favourite_colour: String,
    birthday: String,
    phone_number: String,
    email: String,
    created: String,
    updated: String,
  )
}

pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_contacts(ctx)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn list_contacts(ctx: Context) {
  let sql =
    "
SELECT id, name, phone_number, email
FROM items
ORDER BY name ASC;"

  let assert Ok(rows) =
    sqlight.query(
      sql,
      on: ctx.db,
      with: [],
      expecting: dynamic.decode4(
        PartialContact,
        dynamic.element(0, dynamic.int),
        dynamic.element(1, dynamic.string),
        dynamic.element(2, dynamic.string),
        dynamic.element(3, dynamic.string),
      ),
    )
  io.debug(rows)
  rows
  wisp.html_response(string_builder.from_string("<h1>Hi!</h1>"), 200)
}
