defmodule ExMessenger.Server do
	use GenServer
	require Logger

	def start_link([]) do
		:gen_server.start_link({:local, :message_server}, __MODULE__, [],[])		
	end

	def init([]) do
		{:ok, %{}}
	end

	def handle_call({:connect, nick}, {from, _}, users) do
		cond do
			nick == :server or nick == "server" ->
				{:reply, :nick_not_allowed, users}
			Map.has_key?(users, nick) ->
				{:reply, :nick_already_inuse, users}

			true ->
				new_users = Map.put(users, nick, node(from)) 
				user_list = log(new_users, nick, "has joined!")
				{:reply, {:ok, user_list}, new_users}			
		end
	end

	defp log(users, nick, message) do
		user_list = users |> Map.keys |> Enum.join(":")
		Logger.debug("#{nick} #{message}, user_list : #{user_list}")
		say(nick, message)
		user_list
	end

	def say(nick, message) do
		GenServer.cast(:message_server, {:say, nick, "* #{nick} #{message}*"})
	end

	def handle_cast({:say, nick, message}, users) do
		ears = Map.delete(users, nick)
		Logger.debug("#{nick}  : #{message}")
		broadcast(ears, nick, message)
		{:noreply, users}
	end

	defp broadcast(users, nick, message) do
  		Enum.map(users, fn {_, node} ->
    		Task.async(fn ->
      		send_message_to_client(node, nick, message)
    		end)
  		end)
  		|> Enum.map(&Task.await/1)
	end

	defp send_message_to_client(client_node, nick, message) do
  		GenServer.cast({ :message_handler, client_node }, { :message, nick, message })
	end

end