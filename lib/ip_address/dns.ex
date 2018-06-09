defmodule IpAddress.DNS do
  import Socket.Datagram, only: [send!: 3, recv!: 1]

  @doc """
  Resolves the answer for a IpAddress.DNS query

  Example:

      iex> IpAddress.DNS.resolve("tungdao.com")                      # {:ok, [{1, 1, 1, 1}]}
      iex> IpAddress.DNS.resolve("tungdao.com", :txt)                # {:ok, [['v=spf1 a mx ~all']]}
      iex> IpAddress.DNS.resolve("tungdao.com", :a, {"8.8.8.8", 53}) # {:ok, [{1, 1, 1, 1}]}
  """
  @spec resolve(charlist, atom(), {String.t(), :inet.port()}) :: {atom, :inet.ip()} | {atom, atom}
  def resolve(domain, type \\ :a, dns_server \\ {"8.8.8.8", 53}) do
    case query(domain, type, dns_server).anlist do
      answers when is_list(answers) and length(answers) > 0 ->
        data =
          answers
          |> Enum.map(& &1.data)
          |> Enum.reject(&is_nil/1)

        {:ok, data}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Queries the IpAddress.DNS server and returns the result

  Examples:

      iex> IpAddress.DNS.query("tungdao.com")                              # <= Queries for A records
      iex> IpAddress.DNS.query("tungdao.com", :mx)                         # <= Queries for the MX records
      iex> IpAddress.DNS.query("tungdao.com", :a, { "208.67.220.220", 53}) # <= Queries for A records, using OpenDNS
  """
  def query(domain, type \\ :a, dns_server \\ {"8.8.8.8", 53}) do
    record = %IpAddress.DNS.Record{
      header: %IpAddress.DNS.Header{rd: true},
      qdlist: [%IpAddress.DNS.Query{domain: to_charlist(domain), type: type, class: :in}]
    }

    client = Socket.UDP.open!(0)

    send!(client, IpAddress.DNS.Record.encode(record), dns_server)

    {data, _server} = recv!(client)
    IpAddress.DNS.Record.decode(data)
  end
end
