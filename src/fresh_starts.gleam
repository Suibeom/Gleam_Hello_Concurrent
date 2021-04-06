import gleam/io
import gleam/int
import gleam/list
import gleam/string
import gleam/otp/process.{Pid, Receiver, Sender, receive, start}
import gleam/otp/actor

pub type MyMessage {
  StringMessage(String)
  ShutdownMessage
}

pub fn listener(channel: Receiver(MyMessage)) {
  let message = receive(channel, 2000)
  case message {
    Ok(StringMessage(msg)) -> {
      io.println(msg)
      listener(channel)
    }
    Ok(ShutdownMessage) -> io.println("Process shutting down. Goodbye!")
  }
}

pub fn listener_init(channel: Sender(Sender(MyMessage))) {
  let tuple(sender, receiver) = process.new_channel()
  process.send(channel, sender)
  listener(receiver)
}

pub fn spawn_listener() -> Result(Sender(MyMessage), String) {
  let tuple(sender, receiver) = process.new_channel()

  process.start(fn() { listener_init(sender) })
  case process.receive(receiver, 1000) {
    Ok(new_sender) -> Ok(new_sender)
    Error(_) -> Error("Something fucked up!")
  }
}

pub fn start_process() {
  case spawn_listener() {
    Ok(sender) ->
      process.start(fn() {
        process.send(sender, StringMessage("Hello 1.1!"))
        process.send(sender, StringMessage("Hello 1.2!"))
        process.send(sender, StringMessage("Hello 1.3!"))
        process.send(sender, StringMessage("Hello 1.4!"))
        process.send(sender, StringMessage("Hello 1.5!"))
        process.send(sender, StringMessage("Hello 1.6!"))
        process.send(sender, StringMessage("Hello 1.7!"))
        process.send(sender, StringMessage("Hello 1.8!"))
        process.send(sender, StringMessage("Hello 1.9!"))
        process.send(sender, ShutdownMessage)
      })
  }
  case spawn_listener() {
    Ok(sender) ->
      process.start(fn() {
        process.send(sender, StringMessage("Hello 2.1!"))
        process.send(sender, StringMessage("Hello 2.2!"))
        process.send(sender, StringMessage("Hello 2.3!"))
        process.send(sender, StringMessage("Hello 2.4!"))
        process.send(sender, StringMessage("Hello 2.5!"))
        process.send(sender, StringMessage("Hello 2.6!"))
        process.send(sender, StringMessage("Hello 2.7!"))
        process.send(sender, StringMessage("Hello 2.8!"))
        process.send(sender, StringMessage("Hello 2.9!"))
        process.send(sender, ShutdownMessage)
      })
  }
  case spawn_listener() {
    Ok(sender) -> {
      process.send(sender, StringMessage("Hello 3.1!"))
      process.send(sender, StringMessage("Hello 3.2!"))
      process.send(sender, StringMessage("Hello 3.3!"))
      process.send(sender, StringMessage("Hello 3.4!"))
      process.send(sender, StringMessage("Hello 3.5!"))
      process.send(sender, StringMessage("Hello 3.6!"))
      process.send(sender, StringMessage("Hello 3.7!"))
      process.send(sender, StringMessage("Hello 3.8!"))
      process.send(sender, StringMessage("Hello 3.9!"))
      process.send(sender, ShutdownMessage)
    }
  }
  Ok("All threads spawned just fine.")
}
