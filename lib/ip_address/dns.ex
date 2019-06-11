defmodule IpAddress.DNS do
  import Socket.Datagram, only: [send!: 3, recv!: 1]

  @default_type :a
  @default_server {"8.8.8.8", 53}
  @default_timeout 5_000

  def resolve(domain, opts \\ []) do
    case query(domain, opts) do
      {:ok, query} ->
        case query.anlist do
          answers when is_list(answers) and length(answers) > 0 ->
            data =
              answers
              |> Enum.map(& &1.data)
              |> Enum.reject(&is_nil/1)

            {:ok, data}

          _ ->
            {:error, :not_found}
        end

      {:error, :timeout} ->
        {:error, :timeout}

      _ ->
        {:error, :query_fail}
    end
  end

  def query(domain, opts \\ []) do
    type = Keyword.get(opts, :type, @default_type)
    dns_server = Keyword.get(opts, :server, @default_server)
    timeout = Keyword.get(opts, :timeout, @default_timeout)

    timeout(
      fn ->
        record = %IpAddress.DNS.Record{
          header: %IpAddress.DNS.Header{rd: true},
          qdlist: [%IpAddress.DNS.Query{domain: to_charlist(domain), type: type, class: :in}]
        }

        client = Socket.UDP.open!(0)

        send!(client, IpAddress.DNS.Record.encode(record), dns_server)

        {data, _server} = recv!(client)
        IpAddress.DNS.Record.decode(data)
      end,
      timeout: timeout
    )
  end

  def timeout(call_fn, opts \\ []) do
    try do
      result =
        call_fn
        |> Task.async()
        |> Task.await(opts[:timeout] || @default_timeout)

      {:ok, result}
    catch
      :exit, _ -> {:error, :timeout}
    end
  end
end
