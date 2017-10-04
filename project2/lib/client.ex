defmodule Project2.Client do
	use GenServer

	#client APIs for Project2.Server
	def start(opts) do
		GenServer.start_link(Project2.Server, :ok, name: :gossip_server)
	end

	def update_counter(p_name) do
		GenServer.cast(:gossip_server, {:incr_counter, p_name})
	end

	def print_counters() do
		GenServer.cast(:gossip_server, :print_counters)
	end

	def delete_process() do
		GenServer.call(:gossip_server, :delete_process)
	end

	def create_process_counter(num_nodes) do
		GenServer.cast(:gossip_server, {:create_pcounter, num_nodes})
	end

	def get_process_counter() do
		GenServer.call(:gossip_server, :lookup_pcounter)
	end

	#build a full network
	def build_network1(num_nodes, max_gossip, network_type) do
		
		len = round(:math.sqrt(num_nodes))
		num_nodes = len * len

		IO.puts num_nodes

		#create num_nodes nodes sequentially
		Enum.each(1..num_nodes, 
		 fn (n) -> 
		 	Process.register(spawn(fn -> Project2.Node_Gossip.start(max_gossip) end), String.to_atom("node#{n}"))
		 end)

		#begin gossip with node1
		if Process.alive?(Process.whereis(String.to_atom("node1"))) do

			#create a processes counter in server
			create_process_counter(num_nodes)

			#update_counter(String.to_atom("node1"))
			gossip(Process.whereis(String.to_atom("node1")), "node1", num_nodes, num_nodes, network_type)

			#print_counters()
		end
		
	end

	#build a 2d-grid network
	def build_2d_grid(num_nodes, max_gossip, network_type) do

		len = round(:math.sqrt(num_nodes))
		num_nodes = len * len

		#create num_nodes nodes sequentially
		Enum.each(1..num_nodes, 
		 fn (n) -> 
		 	Process.register(spawn(fn -> Project2.Node_Gossip.start(max_gossip) end), String.to_atom("node#{n}"))
		 end)

		#begin gossip with node1
		if Process.alive?(Process.whereis(String.to_atom("node1"))) do

			#create a processes counter in server
			create_process_counter(num_nodes)

			update_counter(String.to_atom("node1"))
			gossip(Process.whereis(String.to_atom("node1")), "node1", num_nodes, num_nodes, network_type)

			#print_counters()

		end



	end 



	def gossip(from, node_name, num_nodes, c, network_type) do
		#finds its neighbours
		neighbor_name = neighbors_full_network(node_name, num_nodes, network_type)
		neighbor_pid = Process.whereis(String.to_atom(neighbor_name))

		#IO.puts neighbor_name
		Project2.Node_Gossip.send_rumor(neighbor_pid, neighbor_name, from, "Message 1")
		
		"""
		if r != -1 do
			update_counter(String.to_atom(neighbor_name))
		end
		"""

		#:timer.sleep(50)
		#IO.inspect c

		
		if get_process_counter() > 0  do
			gossip(neighbor_pid, neighbor_name, num_nodes, c, network_type)

		end
		
	end

	def neighbors_full_network(node_name, num_nodes, network_type) do
		#find neighbors for a node in full network
		neighbors = []
		rand_no = 0
		case network_type do
			:full ->
				rand_no = Enum.random(1..num_nodes)
				if rand_no == String.to_integer(String.slice(node_name, 4..-1)) do
					neighbors_full_network(node_name, num_nodes, network_type)		
				end

			:grid2d ->
				#find the perfect square for grid breath/depth
				len = round(:math.sqrt(num_nodes))
				value = String.to_integer(String.slice(node_name, 4..-1))

				cond do
					value > 0 and value <= len ->
						#Top Layer of Grid
						cond do
							value == 1  ->
								neighbors = neighbors ++ [value+1] ++ [value+5]

							value > 1 and value < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value+5]	

							value == len  ->
								neighbors = neighbors ++ [value-1] ++ [value+5]
						end
						
					value > len and value <= (num_nodes - len) ->
						#Middle Layers of Grid
						cond do
							rem(value, len) == 1  ->
								neighbors = neighbors ++ [value+1] ++ [value-5]  ++ [value+5]

							rem(value, len) > 1 and rem(value, len) < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value-5] ++ [value+5]	

							rem(value, len) == 0  ->
								neighbors = neighbors ++ [value-1] ++ [value-5] ++ [value+5]
						end						

					value > (num_nodes - len) and value <= num_nodes ->
						#Bottom Layer of Grid
						cond do
							value + len == num_nodes+1  ->
								neighbors = neighbors ++ [value+1] ++ [value-5] 

							rem(value, len) > 1 and rem(value, len) < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value-5] 

							value == num_nodes  ->
								neighbors = neighbors ++ [value-1] ++ [value-5]
						end	
				end
				rand_no = Enum.random(neighbors)

			:grid2dImp ->
				#find the perfect square for grid breath/depth
				len = round(:math.sqrt(num_nodes))
				value = String.to_integer(String.slice(node_name, 4..-1))
				neighbors = neighbors ++ [Enum.random(1..num_nodes)]
				
				
				cond do
					value > 0 and value <= len ->
						#Top Layer of Grid
						cond do
							value == 1  ->
								neighbors = neighbors ++ [value+1] ++ [value+5]

							value > 1 and value < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value+5]	

							value == len  ->
								neighbors = neighbors ++ [value-1] ++ [value+5]
						end
						
					value > len and value <= (num_nodes - len) ->
						#Middle Layers of Grid
						cond do
							rem(value, len) == 1  ->
								neighbors = neighbors ++ [value+1] ++ [value-5]  ++ [value+5]

							rem(value, len) > 1 and rem(value, len) < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value-5] ++ [value+5]	

							rem(value, len) == 0  ->
								neighbors = neighbors ++ [value-1] ++ [value-5] ++ [value+5]
						end						

					value > (num_nodes - len) and value <= num_nodes ->
						#Bottom Layer of Grid
						cond do
							value + len == num_nodes+1  ->
								neighbors = neighbors ++ [value+1] ++ [value-5] 

							rem(value, len) > 1 and rem(value, len) < len ->
								neighbors = neighbors ++ [value-1] ++ [value+1] ++ [value-5] 

							value == num_nodes  ->
								neighbors = neighbors ++ [value-1] ++ [value-5]
						end	
				end
				rand_no = Enum.random(neighbors)	
		end
		"node#{rand_no}"
	end

	def exit_client() do
		exit(:shutdown)
	end






#---------------------------------------------------------------------------------


	def test_something() do

		GenServer.cast(:gossip_server, {:create_pcounter, 10})


		v = GenServer.call(:gossip_server, :delete_process)
		IO.inspect v

		v = GenServer.call(:gossip_server, :delete_process)
		IO.inspect v

		:timer.sleep(:infinity)
		
	end





	#build topology
	def build_network() do
		node1 = spawn(fn -> Project2.Node_Gossip.start() end)
		Process.register(node1, :node1)

		node2 = spawn(fn -> Project2.Node_Gossip.start() end)
		Process.register(node2, :node2)

		node3 = spawn(fn -> Project2.Node_Gossip.start() end)
		Process.register(node3, :node3)


		node1 = Process.whereis(:node1)
		node2 = Process.whereis(:node2)
		node3 = Process.whereis(:node3)
	
		#IO.inspect node1
		#IO.inspect node2
		#IO.inspect node3

		Project2.Node_Gossip.send_rumor(node1, self(), "Message 1")
		Project2.Node_Gossip.send_rumor(node1, self(), "Message 2")
		Project2.Node_Gossip.send_rumor(node1, self(), "Message 3")
		Project2.Node_Gossip.send_rumor(node1, self(), "Message 4")
		
		Project2.Node_Gossip.print_counter(node1, self())
		:timer.sleep(:infinity)
	end


	def gossip2(from, node_name, num_nodes) do
		#finds its neighbours
		rand_neighbor = "node5"
		neighbor_node = Process.whereis(String.to_atom(rand_neighbor))

		Project2.Node_Gossip.send_rumor(neighbor_node, from, "Message 1")

		#gossip(neighbor_node, rand_neighbor, num_nodes)

		gossip2(Process.whereis(String.to_atom("node1")), "node1", num_nodes)

	end


	def test_server() do
		IO.puts "Start Server"
	
    	GenServer.cast(:gossip_server, {:incr_counter, :node1})
    	#:timer.sleep(2000)
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node1})


    	GenServer.cast(:gossip_server, {:incr_counter, :node1})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node1})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, {:incr_counter, :node1})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node1})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, {:incr_counter, :node1})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node1})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, {:incr_counter, :node2})
    	#:timer.sleep(2000)
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node2})


    	GenServer.cast(:gossip_server, {:incr_counter, :node2})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node2})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, {:incr_counter, :node2})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node2})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, {:incr_counter, :node2})
    	_ = GenServer.call(:gossip_server, {:lookup_counter, :node2})
		IO.puts "End Server"

		GenServer.cast(:gossip_server, :print_counters)

		:timer.sleep(:infinity)
	end


end