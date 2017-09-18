defmodule BitcoinMiner.Client do
	@moduledoc """
	This is a client worker, which interacts with a given server : BitcoinMiner.Server 
	and creates a seperate HashBucket and registers it with the Server.
	Every new Instance of BitcoinMiner will be registered with The `BitcoinMiner.Server` with
	a separate name
	"""
	def start_mining(server_name, client_name, input, k) do
		#start the client
		BitcoinMiner.Client.start_client(server_name, client_name)
		{:ok, client_bucket} = BitcoinMiner.Client.lookup_clientid_in_server(server_name, client_name)
		
		#Generated hard-coded bitcoin	
		BitcoinMiner.Client.gen_coin_frm_ip_and_update_bucket_server(client_bucket, input,  k)

		#Generate more bitcoins
		for i <- 0..100, do:
		spawn_link(fn -> BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k) end)
		
		#get all the bitcoins from this bucket
		BitcoinMiner.Client.get_all_coins_from_bucket(client_bucket)

	end

	def start_client(server_name, client_name) do		
		BitcoinMiner.Server.create(server_name, client_name)		
	end

	def lookup_clientid_in_server(server_name, client_name) do
		{:ok, client_bucket} = BitcoinMiner.Server.lookup(server_name, client_name)
	end

	def gen_coin_and_update_bucket_server(client_bucket, k) do
		BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k) 
	end

	def gen_coin_frm_ip_and_update_bucket_server(client_bucket, input, k) do
		BitcoinMiner.HashBucket.gen_coin_update_bucket(client_bucket, input, k) 
	end

	def get_all_coins_from_bucket(client_bucket) do
		BitcoinMiner.HashBucket.get_all_coins(client_bucket)
	end

end