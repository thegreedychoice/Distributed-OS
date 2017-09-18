defmodule BitcoinMiner.Server do
	use GenServer
	@moduledoc """
	This module serves as a registry which keeps track of the different buckets(buckets pid) with names
	The module is divided into two sections -

	Client API :
		It calls the server to create and fetch the bucket pid, via a key.

	Server API :
		It maintains a dictionary/map/registry of the buckets pids and interacts with the client with 
		apt responses.

		The server itself interacts with the buckets which are seperate process initself and are not hosted by 
		the server.

	This server maintains a state/registry of all client buckets(names and references)
	"""

    ## Client API

  	@doc """
  	Starts the registry.
  	"""
  	def start_link(opts) do
    	GenServer.start_link(__MODULE__, :ok, opts)
  	end

  	@doc """
  	Looks up the bucket pid for `name` stored in `server`.

  	Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  	"""
  	def lookup(server, name) do
    	GenServer.call(server, {:lookup, name})
  	end

  	@doc """
  	Ensures there is a bucket associated with the given `name` in `server`.
  	"""
  	def create(server, name) do
    	GenServer.cast(server, {:create, name})
  	end

	@doc """
	Stops the registry.
	"""
	def stop(server) do
	  GenServer.stop(server)
	end

  	#Server Callbacks
  	@doc """
  	Initializes the state and returns {:ok, state}
  	"""
  	def init(opts) do
  		names = %{}
  		#refs = %{}
  		{:ok, names}
  	end

  	@doc """
  	Handle Synchronous calls and server needs to send a reply
  	Expected paramters : (request, caller_pid, state)
  	Returns : {:reply, reply, new_state}
  	"""
  	def handle_call({:lookup, name}, _from, names) do
  		{:reply, Map.fetch(names, name), names}
  	end

  	@doc """
  	Handle Asynchronous calls and server doesn't need to send a reply
  	Expected paramters : (request, caller_pid, state)
  	Returns : {:noreply, new_state}
  	"""
  	def handle_cast({:create, name}, names) do
  		if Map.has_key?(names, name) do
  			{:noreply, names}
  		else
  			{:ok, bucket} = BitcoinMiner.HashBucket.start_link([])
  			#ref = Process.monitor(pid)
  			#refs = Map.put(refs, ref, name)
  			names = Map.put(names, name, bucket)
  			{:noreply, names}
  		end
  	end

end