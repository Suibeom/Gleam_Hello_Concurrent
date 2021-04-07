import fresh_starts
import gleam/should

pub fn hello_world_test() {
  Ok("Nothing to test here really")
  |> should.be_ok()
}
