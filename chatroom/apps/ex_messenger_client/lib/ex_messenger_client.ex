defmodule ExMessengerClient do
  @moduledoc """
  Documentation for ExMessengerClient.
  """
  use Application
  alias ExMessengerClient.ServerProtocol
  alias ExMessengerClient.CLI

  def start(_type,_args) do
    get_env
    |>connect
    |>start_message_handler
    |>join_chatroom
    |>CLI.input_loop
  end
  @doc """
  Reads the Environment variables from the command line
  """
  defp get_env() do

    #get the name of the server from Environment Variables from command line
    server = System.get_env("server")
    |>String.trim_trailing()
    |>String.to_atom

    #get the nick name from Environment Variables from command line
    nick = System.get_env("nick_name")
    |>String.trim_trailing()

    {server, nick}
  end
@doc """
This method tries to connect with the server
"""
defp connect({server,nick}) do

  IO.puts "Connecting to #{server} from #{Node.self}..."
  #We set the cookie in the client's instance otherwise Node.connect() would fail
  Node.set_cookie(Node.self, ":chocolate-chip")
  case Node.connect(server) do
    true -> :ok
    reason ->
      IO.puts "Could not connect to the server, reason : #{reason}"
      System.halt(0)
  end
  {server, nick}
end

@doc """
This method starts the Client Message Handler GenSever
"""
defp start_message_handler({server, nick}) do

  ExMessengerClient.MessageHandler.start_link(server)
  IO.puts "Connected!"
  {server, nick}
end

@doc """
This method contacts the server and joins the client in our pseudo-chat room.
"""
defp join_chatroom({server, nick}) do

  case ServerProtocol.connect({server, nick}) do
    {:ok, users} -> 
      IO.puts "* Joined the chatroom *"
      IO.puts "* Users in the room: #{users} *"
      IO.puts "* Type /help for options *"

    reason ->
      IO.puts "Could not join the chatroom, reason: #{reason}"
      System.halt(0)
  end
  {server, nick} 
end


end
