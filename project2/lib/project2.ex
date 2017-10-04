defmodule Project2 do
  @moduledoc """
  Documentation for Project2.
  """
  use GenServer

  def main(args) do
    #get the parameters from the command line
    [num_nodes | t] = parse_args(args)
    [top | algo] = t

    #step 1 : build the topology
    {:ok, server} = Project2.Client.start([])
    IO.inspect server
    
    
    #step 2 : start communication full network
    start = :os.system_time(:micro_seconds)
    Project2.Client.build_network1(1000, 25, :full)
    finish = :os.system_time(:micro_seconds)
    IO.puts "Total Completion time for Gossip in Full Network : #{finish - start} microseconds" 
    

    #step 2 : start communication 2d-grid
    start = :os.system_time(:micro_seconds)
    Project2.Client.build_2d_grid(100, 5, :grid2d)
    finish = :os.system_time(:micro_seconds)
    IO.puts "Total Completion time for Gossip in 2dGrid Network : #{finish - start} microseconds" 

    #step 2 : start communication Imperfect 2d-grid
    start = :os.system_time(:micro_seconds)
    Project2.Client.build_2d_grid(100, 5, :grid2dImp)
    finish = :os.system_time(:micro_seconds)
    IO.puts "Total Completion time for Gossip in Imperfect 2dGrid Network : #{finish - start} microseconds" 
    

    :timer.sleep(:infinity)
  end

 

  defp parse_args(args) do
    {_, _, _} = OptionParser.parse(args,
       switches: [foo: :string]
    )
    args
  end  
end
