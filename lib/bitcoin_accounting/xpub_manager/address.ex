defmodule BitcoinAccounting.XpubManager.Address do
  alias BitcoinLib.Address
  alias BitcoinLib.Key.{PublicKey}

  require Logger

  def from_xpub(xpub, change?, index) do
    case PublicKey.deserialize(xpub) do
      {:ok, public_key, network, :bip32} ->
        get_address(public_key, network, :p2pkh, change?, index)

      {:ok, public_key, network, :bip49} ->
        get_address(public_key, network, :p2sh, change?, index)

      {:ok, public_key, network, :bip84} ->
        get_address(public_key, network, :p2wpkh, change?, index)

      {:error, message} ->
        Logger.error(message)

      unknown ->
        Logger.error(unknown |> inspect)
    end
  end

  defp get_address(public_key, network, type, change?, index) do
    public_key
    |> PublicKey.derive_child!(get_change_id(change?))
    |> PublicKey.derive_child!(index)
    |> Address.from_public_key(type, network)
    |> format(change?, index)
  end

  defp get_change_id(true), do: 1
  defp get_change_id(false), do: 0

  defp format(address, change?, index) do
    %{
      address: address,
      change?: change?,
      index: index
    }
  end
end
