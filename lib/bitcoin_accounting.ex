defmodule BitcoinAccounting do
  alias BitcoinLib.Key.{PublicKey, PublicKeyHash, Address}

  def get_book_entries(xpub) do
    xpub
    |> get_address_range(false, 0..19)
    |> extract_book_entries()
  end

  defp get_address_range(xpub, change?, range) do
    change_index = get_change_index(change?)

    range
    |> Enum.map(fn index ->
      xpub
      |> PublicKey.deserialize!()
      |> PublicKey.derive_child!(change_index)
      |> PublicKey.derive_child!(index)
      |> PublicKeyHash.from_public_key()
      |> Address.from_public_key_hash(:p2pkh, :testnet)
    end)
  end

  defp extract_book_entries(address_range) do
    address_range
    |> Enum.map(fn address ->
      history =
        ElectrumClient.get_address_history(address)
        |> Enum.map(fn history_item ->
          ElectrumClient.get_transaction(history_item.txid)
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
