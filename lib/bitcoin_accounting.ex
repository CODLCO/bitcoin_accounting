defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressRange, JournalEntries}

  @get_book_entries_defaults %{empty_address_count: 20}

  @spec get_book_entries(binary()) :: list()
  def get_book_entries(xpub, opts \\ []) do
    %{empty_address_count: empty_address_count} = Enum.into(opts, @get_book_entries_defaults)

    receive_entries =
      xpub
      |> AddressRange.get_address_range(false, 0..(empty_address_count - 1))
      |> extract_book_entries()

    change_entries =
      xpub
      |> AddressRange.get_address_range(true, 0..(empty_address_count - 1))
      |> extract_book_entries()

    %{
      receive: receive_entries,
      change: change_entries
    }
  end

  def get_address_history(address) do
    address
    |> ElectrumClient.get_address_history()
    |> Enum.map(fn history_item ->
      get_journal_entries(history_item, address)
    end)
  end

  defp extract_book_entries(address_range) when is_list(address_range) do
    address_range
    |> Enum.map(fn address ->
      extract_book_entries(address)
    end)
  end

  defp extract_book_entries(address) when is_binary(address) do
    history = get_address_history(address)

    %{address: address, history: history}
  end

  defp get_journal_entries(%{txid: transaction_id}, address) do
    ElectrumClient.get_transaction(transaction_id)
    |> JournalEntries.from_transaction_request(address)
  end
end
