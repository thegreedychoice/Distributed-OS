defmodule Project1 do
  use Application
  @moduledoc """
  Documentation for Project1.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Project1.hello
      :world

  """
  def hello do
    :world
  end



  def start(_type, _args) do
    BitcoinMiner.Supervisor.start_link(name: BitcoinMiner.Supervisor)
  end

end

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end