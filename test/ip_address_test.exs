defmodule IpAddressTest do
  use ExUnit.Case
  doctest IpAddress

  test "find nil" do
    assert IpAddress.find(nil) == {:error, :null}
  end

  test "find \"\"" do
    assert IpAddress.find("") == {:error, :empty}
  end

  test "find! nil" do
    assert IpAddress.find!(nil) == []
  end

  test "find! \"\"" do
    assert IpAddress.find!("") == []
  end

end
