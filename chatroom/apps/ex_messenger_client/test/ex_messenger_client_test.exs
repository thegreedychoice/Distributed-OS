defmodule ExMessengerClientTest do
  use ExUnit.Case
  doctest ExMessengerClient

  test "greets the world" do
    assert ExMessengerClient.hello() == :world
  end
end
