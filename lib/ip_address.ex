defmodule IpAddress do
  def find(nil), do: {:error, :null}
  def find(""), do: {:error, :empty}

  def find(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find(ip_string)
  end

  def find(ip_strings) when is_list(ip_strings) do
    ip_strings
    |> Enum.uniq
    |> Enum.map(fn ip_string ->
      {ip_string, find(ip_string)}
    end)
  end

  def find!(nil), do: []

  def find!(ip_string) when is_binary(ip_string) do
    IpAddress.Monipdb.find!(ip_string)
  end

  def find!(ip_strings) when is_list(ip_strings) do
    ip_strings
    |> Enum.uniq
    |> Enum.map(fn ip_string ->
      {ip_string, find!(ip_string)}
    end)
  end

end
