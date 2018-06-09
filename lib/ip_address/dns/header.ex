defmodule IpAddress.DNS.Header do
  @moduledoc """
  TODO: docs
  """

  record = Record.extract(:dns_header, from_lib: "kernel/src/inet_dns.hrl")
  keys = :lists.map(&elem(&1, 0), record)
  vals = :lists.map(&{&1, [], nil}, keys)
  pairs = :lists.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `IpAddress.DNS.Header` struct to a `:dns_header` record.
  """
  def to_record(%IpAddress.DNS.Header{unquote_splicing(pairs)}) do
    {:dns_header, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_header` record into a `IpAddress.DNS.Header`.
  """
  def from_record(file_info)

  def from_record({:dns_header, unquote_splicing(vals)}) do
    %IpAddress.DNS.Header{unquote_splicing(pairs)}
  end
end
