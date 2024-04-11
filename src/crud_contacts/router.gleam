import wisp.{type Request, type Response}
import crud_contacts/contacts
import crud_contacts/web.{type Context}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [""] | ["contacts"] -> contacts.all(req, ctx)
    _ -> wisp.not_found()
  }
}
