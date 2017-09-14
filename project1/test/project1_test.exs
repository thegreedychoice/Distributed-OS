defmodule Project1Test do
  use ExUnit.Case
  doctest Project1

  test "greets the world" do
    assert Project1.hello() == :world
  end

  test "SHA-256 hashing" do
  	value = "Shubham123"
  	assert Project1.BitcoinMiner.get_hash(value) == "05f2bd2e80f900976788c4e4b483da1e3ac2d477f2a7345b6e484495aed2107a"
  end

  test "Hash Leading Zeros" do
  	value = SHA-256 do
  		assert Project1.BitcoinMiner.get_zeros(value) == 1
  	end
  end
end
