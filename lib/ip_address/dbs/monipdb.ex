defmodule IpAddress.Monipdb do
  def find(ip_string) when is_binary(ip_string) do
    try do
      case _find_from_erl(ip_string) do
        {:ok, address_string} ->
          addresses =
            String.split(address_string, "\t")
            |> Enum.filter(fn str ->
              String.length(str) > 0
            end)
            |> Enum.uniq()

          {:ok, addresses}

        _ ->
          {:error, :not_found}
      end
    rescue
      _ in [MatchError] ->
        {:error, :nxdomain}

      true ->
        {:error, :nxdomain}
    end
  end

  def find!(ip_string) when is_binary(ip_string) do
    case find(ip_string) do
      {:ok, addresses} -> addresses
      {:error, _} -> []
    end
  end

  defp _find_from_erl(ip_string) when is_binary(ip_string) do
    :ip_address_erl.find(
      String.to_charlist(ip_string),
      Path.absname("17monipdb.dat", Application.app_dir(:ip_address, "priv"))
    )
  end
end
