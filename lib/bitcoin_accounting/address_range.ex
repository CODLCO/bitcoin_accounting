defmodule BitcoinAccounting.AddressRange do
  require Logger

  alias BitcoinLib.Key.{PublicKey, Address}

  def get_address_range(xpub, change?, range) do
    case PublicKey.deserialize(xpub) do
      {:ok, public_key, network, :bip32} ->
        get_bip32_address_range(public_key, network, change?, range)

      {:ok, public_key, network, :bip49} ->
        get_bip49_address_range(public_key, network, change?, range)

      {:ok, public_key, network, :bip84} ->
        get_bip84_address_range(public_key, network, change?, range)

      {:error, message} ->
        Logger.error(message)

      unknown ->
        Logger.error(unknown |> inspect)
    end
  end

  defp get_bip32_address_range(public_key, network, change?, range) do
    change_index = get_change_index(change?)

    range
    |> Enum.map(fn index ->
      public_key
      |> PublicKey.derive_child!(change_index)
      |> PublicKey.derive_child!(index)
      |> Address.from_public_key(:p2pkh, network)
    end)
  end

  defp get_bip49_address_range(public_key, network, change?, range) do
    change_index = get_change_index(change?)

    range
    |> Enum.map(fn index ->
      public_key
      |> PublicKey.derive_child!(change_index)
      |> PublicKey.derive_child!(index)
      |> Address.from_public_key(:p2sh, network)
    end)
  end

  defp get_bip84_address_range(public_key, network, change?, range) do
    change_index = get_change_index(change?)

    range
    |> Enum.map(fn index ->
      public_key
      |> PublicKey.derive_child!(change_index)
      |> PublicKey.derive_child!(index)
      |> Address.from_public_key(:bech32, network)
    end)
  end

  defp get_change_index(change?) do
    case change?,
      do:
        (
          true -> 1
          false -> 0
        )
  end
end
