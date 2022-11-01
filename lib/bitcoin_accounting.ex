defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressRange, JournalEntries}

  @spec get_book_entries(binary()) :: list()
  def get_book_entries(xpub, change_chain? \\ false) do
    xpub
    |> AddressRange.get_address_range(change_chain?, 0..19)
    |> extract_book_entries()
  end

  def get_address_history(address) do
    address
    |> ElectrumClient.get_address_history()
    |> Enum.map(fn history_item ->
      get_journal_entries(history_item, address)
    end)
  end

  defp extract_book_entries(address_range) do
    address_range
    |> Enum.map(fn address ->
      history = get_address_history(address)

      %{address: address, history: history}
    end)
  end

  defp get_journal_entries(%{txid: transaction_id}, address) do
    ElectrumClient.get_transaction(transaction_id)
    |> JournalEntries.from_transaction_request(address)
  end
end
