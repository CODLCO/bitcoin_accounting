defmodule BitcoinAccounting.XpubManager.AddressInfo do
  @moduledoc """
  Converts an xpub into an address along with derivation path starting from the xpub
  """

  defstruct [:address, :change?, :index]

  alias BitcoinLib.Address
  alias BitcoinLib.Key.{PublicKey}
  alias BitcoinAccounting.XpubManager.AddressInfo

  require Logger

  @doc """
  Converts an xpub into an address

  ## Examples

      iex> "tpubDDJMFT1RGo7pAQxLSFSawLMBJGVizgq4Ny9hYmHWJCYTDW6JsGu3ZqU1RBVPJFhMJjr44fcdeny3uRjQmtUsH1dtuTQG9Ni29AHGwYK56Zq"
      ...> |> BitcoinAccounting.XpubManager.AddressInfo.from_xpub(false, 0)
      {
        :ok,
        %AddressInfo{address: "mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L", change?: false, index: 0}
      }
  """
  def from_xpub(xpub, change?, index) do
    case PublicKey.deserialize(xpub) do
      {:ok, public_key, network, :bip32} ->
        get_address(public_key, network, :p2pkh, change?, index)

      {:ok, public_key, network, :bip49} ->
        get_address(public_key, network, :p2sh, change?, index)

      {:ok, public_key, network, :bip84} ->
        get_address(public_key, network, :p2wpkh, change?, index)

      {:ok, _, _, key_type} ->
        {:error, "trying to deserialize an xpub with an unknown key type: #{key_type}"}

      {:error, message} ->
        {:error, message}
    end
  end

  defp get_address(_, _, _, _, index) when index < 0, do: {:error, "the index must not be a negative integer"}

  defp get_address(public_key, network, type, change?, index) do
    with {:ok, change_public_key} <- PublicKey.derive_child(public_key, get_change_id(change?)),
         {:ok, index_public_key} <- PublicKey.derive_child(change_public_key, index) do
      address =
        index_public_key
        |> Address.from_public_key(type, network)
        |> format(change?, index)

      {:ok, address}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp get_change_id(true), do: 1
  defp get_change_id(false), do: 0

  defp format(address, change?, index) do
    %AddressInfo{
      address: address,
      change?: change?,
      index: index
    }
  end
end
