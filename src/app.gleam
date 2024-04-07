import gleam/io
import gleam/erlang/process
import wisp
import mist

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  io.debug(wisp.random_string(5))
}
