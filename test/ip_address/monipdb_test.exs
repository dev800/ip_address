defmodule IpAddress.MonipdbTest do
  use ExUnit.Case

  alias IpAddress.Monipdb, as: Monipdb

  test "find" do
    assert Monipdb.find("115.29.161.118") == {:ok, ["中国", "浙江", "杭州"]}
  end

  test "find!" do
    assert Monipdb.find!("115.29.161.118") == ["中国", "浙江", "杭州"]
  end
end
