defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressRange, JournalEntries}

  @spec get_book_entries(binary()) :: list()
  def get_book_entries(xpub) do
    xpub
    |> AddressRange.get_address_range(false, 0..19)
    |> extract_book_entries()
  end

  defp extract_book_entries(address_range) do
    address_range
    |> Enum.map(fn address ->
      history =
        ElectrumClient.get_address_history(address)
        |> Enum.map(fn history_item ->
          ElectrumClient.get_transaction(history_item.txid)
          |> JournalEntries.from_transaction_request(address)
        end)

      %{address: address, history: history}
    end)
  end
end
