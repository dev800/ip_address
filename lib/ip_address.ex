defmodule IpAddress do
  def find(nil), do: {:error, :null}
  def find(""), do: {:error, :empty}

  def find(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find(ip_string)
  end

  def find!(nil), do: []

  def find!(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find!(ip_string)
  end
end
