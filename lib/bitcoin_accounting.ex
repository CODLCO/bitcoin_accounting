defmodule BitcoinAccounting do
  require Logger

  alias BitcoinAccounting.JournalEntries
  alias BitcoinLib.Key.{PublicKey, Address}

  @spec get_book_entries(binary()) :: list()
  def get_book_entries(xpub) do
    xpub
    |> get_address_range(false, 0..19)
    |> extract_book_entries()
  end

  defp get_address_range(xpub, change?, range) do
    case PublicKey.deserialize(xpub) do
      {:ok, public_key, network, :bip32} ->
        get_bip32_address_range(public_key, network, change?, range)

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
      |> PublicKey.hash()
      |> Address.from_public_key_hash(:p2pkh, network)
    end)
  end

  defp extract_book_entries(address_range) do
    address_range
    |> Enum.map(fn address ->
      history =
        ElectrumClient.get_address_history(address)
        |> Enum.map(fn history_item ->
          ElectrumClient.get_transaction(history_item.txid)
          |> JournalEntries.from_transaction(address)
        end)

      %{address: address, history: history}
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
