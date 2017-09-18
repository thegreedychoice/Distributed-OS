defmodule BitcoinMiner.HashBucket do
	use Agent, restart: :temporary

	#Agent API

	@doc """
  	Starts a new hash bucket.
  	"""
	def start_link(_opts) do
		Agent.start_link(fn -> %{} end)
	end
	@doc """
	Gets a value from the bucket
	"""
	def get(bucket, key) do
		Agent.get(bucket, &Map.get(&1, key))
	end

	@doc """ 
	Puts a value into our bucket with a given key
	"""
	def put(bucket, key, value) do
		Agent.update(bucket, &Map.put(&1, key, value))
	end

	@doc """ 
	Gets all the coins from the bucket
	"""
	def get_all_coins(bucket) do
		Agent.get(bucket, &Map.to_list(&1))
	end

	#Bitcoin Mining

	def gen_rand_coin_update_bucket(bucket, k) do
		#First generate a random string
		rand_no = :crypto.strong_rand_bytes(10) |> Base.encode16
		input = "4124-3903;#{rand_no}"

		#find the hash for the input
		hash = get_hash(input)

		status = get_leading_zeros(hash |> String.graphemes, 0) 
				|> check_zeros(k)

		if status == Elixir.True do
			put(bucket, input, hash)
		end

		status
	end


	def gen_coin_update_bucket(bucket, input, k) do
		#First generate a random string
		rand_no = :crypto.strong_rand_bytes(10) |> Base.encode16
		#input = "4124-3903;#{rand_no}"

		#find the hash for the input
		hash = get_hash(input)

		status = get_leading_zeros(hash |> String.graphemes, 0) 
				|> check_zeros(k)

		if status == Elixir.True do
			put(bucket, input, hash)
		end

	end

	def print_args(args) do
		IO.puts args

	end

	def get_hash(value) do
		:crypto.hash(:sha256, value)
		|>Base.encode16
		|>String.downcase
	end

	def get_leading_zeros(value, count) do
		[h|t] = value
		if h == "0" do
			get_leading_zeros(t, count+1)
		else 
			count
		end

	end

	def check_zeros(c, k) do
		if c == k do
			True
		else
			False
		end
	end
end