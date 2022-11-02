defmodule BitcoinAccounting.AddressManager do
  alias BitcoinAccounting.{JournalEntries}

  def get_history(address) do
    address
    |> ElectrumClient.get_address_history()
    |> Enum.map(fn history_item ->
      get_journal_entries(history_item, address)
    end)
  end

  def extract_book_entries(address_range) when is_list(address_range) do
    address_range
    |> Enum.map(fn address ->
      extract_book_entries(address)
    end)
  end

  def extract_book_entries(address) when is_binary(address) do
    history = get_history(address)

    %{address: address, history: history}
  end

  defp get_journal_entries(%{txid: transaction_id}, address) do
    ElectrumClient.get_transaction(transaction_id)
    |> JournalEntries.from_transaction_request(address)
  end
end
