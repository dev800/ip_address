defmodule IpAddress do
  def find(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find(ip_string)
  end

  def find!(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find!(ip_string)
  end
end
