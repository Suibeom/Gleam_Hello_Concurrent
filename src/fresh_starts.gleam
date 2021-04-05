import gleam/io
import gleam/int
import gleam/list
import gleam/string
import gleam/otp/process.{Pid, Receiver, Sender, receive, start}
import gleam/otp/actor

pub fn listener(channel: Receiver(String)) {
  let message = receive(channel, 2000)
  case message {
    Ok(msg) -> io.println(msg)
    _ -> Nil
  }

  listener(channel)
}

pub fn listener_init(channel: Sender(Sender(String))) {
  let tuple(sender, receiver) = process.new_channel()
  process.send(channel, sender)
  listener(receiver)
}

pub fn spawn_listener() -> Result(Sender(String), String) {
  let tuple(sender, receiver) = process.new_channel()

  let child = process.start(fn() { listener_init(sender) })
  case process.receive(receiver, 1000) {
    Ok(new_sender) -> Ok(new_sender)
    Error(_) -> Error("Something fucked up!")
  }
}

pub fn start_proess() {
  case spawn_listener() {
    Ok(sender) ->
      process.start(fn() {
        process.send(sender, "Hello 1.1!")
        process.send(sender, "Hello 1.2!")
        process.send(sender, "Hello 1.3!")
        process.send(sender, "Hello 1.4!")
        process.send(sender, "Hello 1.5!")
        process.send(sender, "Hello 1.6!")
        process.send(sender, "Hello 1.7!")
        process.send(sender, "Hello 1.8!")
        process.send(sender, "Hello 1.9!")
      })
  }
  case spawn_listener() {
    Ok(sender) ->
      process.start(fn() {
        process.send(sender, "Hello 2.1!")
        process.send(sender, "Hello 2.2!")
        process.send(sender, "Hello 2.3!")
        process.send(sender, "Hello 2.4!")
        process.send(sender, "Hello 2.5!")
        process.send(sender, "Hello 2.6!")
        process.send(sender, "Hello 2.7!")
        process.send(sender, "Hello 2.8!")
        process.send(sender, "Hello 2.9!")
      })
  }
  case spawn_listener() {
    Ok(sender) -> {
      process.send(sender, "Hello 3.1!")
      process.send(sender, "Hello 3.2!")
      process.send(sender, "Hello 3.3!")
      process.send(sender, "Hello 3.4!")
      process.send(sender, "Hello 3.5!")
      process.send(sender, "Hello 3.6!")
      process.send(sender, "Hello 3.7!")
      process.send(sender, "Hello 3.8!")
      process.send(sender, "Hello 3.9!")
    }
  }
}
