defmodule ExMessengerTest do
  use ExUnit.Case
  doctest ExMessenger

  test "greets the world" do
    assert ExMessenger.hello() == :world
  end
end
