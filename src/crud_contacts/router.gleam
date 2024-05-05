import gleam/string_builder
import gleam/io
import gleam/int
import gleam/result
import gleam/list
import gleam/http.{Get, Post}
import wisp.{type Request, type Response}
import crud_contacts/web.{type Context}
import crud_contacts/contact.{type FormData}
import crud_contacts/template

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    _ -> home(req, ctx)
  }
}

fn home(req: Request, ctx: Context) {
  case req.method {
    Post -> create_contact(req, ctx)
    Get -> {
      template.home_page(contact.list(ctx))
      |> string_builder.from_string()
      |> wisp.html_response(200)
    }
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn create_contact(req, ctx) {
  use formdata <- wisp.require_form(req)
  let name =
    result.unwrap(list.key_find(formdata.values, "name"), "Default name")
  let favourite_colour =
    result.unwrap(
      list.key_find(formdata.values, "favourite_colour"),
      "Default colour",
    )
  let phone =
    result.unwrap(list.key_find(formdata.values, "phone"), "Default phone")
  let email =
    result.unwrap(list.key_find(formdata.values, "email"), "Default email")
  let data = contact.FormData(name, favourite_colour, phone, email)
  let id = result.unwrap(contact.new(data, ctx), -1)

  template.base_page(
    title: "Created",
    content: "<h1>Created contact id " <> int.to_string(id) <> "</h1>",
  )
  |> string_builder.from_string()
  |> wisp.html_response(201)
}
