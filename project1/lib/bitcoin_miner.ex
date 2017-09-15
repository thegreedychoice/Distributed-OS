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

	def check_zeros(value) do
		
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