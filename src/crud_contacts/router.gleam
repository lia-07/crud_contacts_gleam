import gleam/string_builder
import wisp.{type Request, type Response}
import crud_contacts/web.{type Context}
import crud_contacts/template

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    _ -> home()
  }
}

fn home() {
  template.base_page("Contacts", "<h1>Contacts</h1>")
  |> string_builder.from_string()
  |> wisp.html_response(200)
}
