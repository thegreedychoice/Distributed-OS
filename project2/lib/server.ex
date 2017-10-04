defmodule Project2.Server do
  use GenServer

  ## Client API

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """





  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup_counter, p_name}, _from, counters) do
  	value = Map.fetch(counters, p_name)
    IO.inspect value
    {:reply, Map.fetch(counters, p_name), counters}
  end

  def handle_cast({:incr_counter, p_name}, counters) do
    if Map.has_key?(counters, p_name) and Process.whereis(p_name) do
      {_, value} = Map.fetch(counters, p_name)
      {:noreply, Map.put(counters, p_name, (value+1))}

    else
      {:noreply, Map.put(counters, p_name, 1)}
    end
  end

  def handle_cast(:print_counters, counters) do
  	Enum.each(counters, fn({k, x}) ->
  	IO.puts("#{k} => #{x}")
	end)
	IO.puts ""
	{:noreply, counters}
  end

  #decrement process counter when a node stops working
  def handle_call(:delete_process, _from, counters) do
  	{_, value} = Map.fetch(counters, "countp")
  	{:reply, (value-1), Map.put(counters, "countp", (value-1))}
  end

  def handle_call(:lookup_pcounter, _from, counters) do
  	{_, value} = Map.fetch(counters, "countp")
  	{:reply, value, counters}
  end

  def handle_cast({:create_pcounter, value}, counters) do
  	{:noreply, Map.put(counters, "countp", value)}
  end

end