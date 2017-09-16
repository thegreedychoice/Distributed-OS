defmodule ExMessengerClient.MessageHandler do
	@moduledoc """
	This module starts a GenServer for Client which handles incoming messages from the server
	and puts the messages in the client's terminal
	"""
	use GenServer

	def start_link(server) do
		GenServer.start_link({:local, :MessageHandler}, __MODULE__, server, [])
	end

	def init(server) do
		{:ok, server}
	end

	def handle_cast({:message, nick, message}, server) do
		message = message |> String.trim_trailing
		IO.puts "\n#{server}>#{nick}: #{message}"
		IO.write "#{Node.self}>"
		{:noreply, server}
	end
end