defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressManager, XpubManager}
  alias BitcoinAccounting.AddressManager.JournalEntries
  @get_book_entries_defaults %{gap_limit_stop: 20}

  @spec get_book_entries(binary(), list()) :: %{receive: list(), change: list()}
  def get_book_entries(xpub, opts \\ []) do
    %{gap_limit_stop: gap_limit_stop} = Enum.into(opts, @get_book_entries_defaults)

    xpub
    |> XpubManager.entries_for(gap_limit_stop)
    |> JournalEntries.for_xpub()
  end

  def get_address_history(address) do
    address
    |> AddressManager.history_for()
    |> Enum.map(fn history_item ->
      JournalEntries.from_transaction_request(history_item, address)
    end)
  end
end
