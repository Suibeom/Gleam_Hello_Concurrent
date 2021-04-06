import fresh_starts
import gleam/should

pub fn hello_world_test() {
  fresh_starts.start_process()
  |> should.be_ok()
}
