defmodule Project1.BitcoinMiner do
	use GenServer

	def start_link(options \\ []) do
		GenServer.start_link(__MODULE__, options, [])
	end
	#Server API
	def init(_) do
		{:ok, []}
	end

	def main(args) do
		args
		|>parse_args
		|>print_args
	end

	def print_args(args) do
		IO.puts 

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


	def start_process(k) do
		#generate string
		rand_no = :crypto.strong_rand_bytes(10) |> Base.encode16
		str = "4124-3903;#{rand_no}"
		
		hash = get_hash(str)

		status = get_leading_zeros(hash |> String.graphemes, 0) 
				|> check_zeros(k)
		
		#IO.puts status
		
	end

	def generate_strings_counter(initial) do
		h = "4124-3903"	
	end

	def print_result() do
		
	end

	defp parse_args(args) do
		{_, _, _} = OptionParser.parse(args,
      	switches: [foo: :string]
    	)
    args
    end


	def handle_call({:store, item}, _from, state) do
		{:reply, :ok, [item | state]}
	end

	
end