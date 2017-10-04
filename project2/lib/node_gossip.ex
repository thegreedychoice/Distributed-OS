defmodule Project2.Node_Gossip do
	use Agent


	#Node/Process APIs
	def start(max_gossip) do
		initial = 0
		loop(initial, max_gossip)
	end

	def loop(counter, max_gossip) do
		receive do 
			{:rumor, msg, p_name, from} ->
				if counter < max_gossip and Process.whereis(String.to_atom(p_name)) do
					counter = counter + 1

					if counter == max_gossip do
						#IO.inspect String.to_atom(p_name), label: "Counter : #{counter} and PID : "
					end

					Project2.Client.update_counter(String.to_atom(p_name))
					loop(counter, max_gossip)
				else
					_ = Project2.Client.delete_process()
					Process.exit(self(), :normal)
				end

			{:print_counter, from} ->
				IO.puts "Current Counter Value: #{counter}"
		end
		
	end

	def send_rumor(to_pid, to_name, from_pid, msg) do
		#IO.puts "Send_rumor #{msg}!"
		if to_pid != nil do
			send(to_pid, {:rumor, msg, to_name, from_pid})
		end
	end

	def print_counter(to_pid, from_pid) do
		if to_pid != nil do
			send(to_pid, {:print_counter, from_pid})
		end
	end
	

end