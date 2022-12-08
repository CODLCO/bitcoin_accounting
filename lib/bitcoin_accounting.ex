defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressManager, XpubManager}
  alias BitcoinAccounting.JournalReport
  alias BitcoinAccounting.XpubManager.{AddressGenerator, AddressInfo}

  @gap_limit 20
  @get_book_entries_defaults %{gap_limit_stop: @gap_limit}

  @spec get_book_entries(binary(), list()) :: %{receive: list(), change: list()}
  def get_book_entries(xpub, opts \\ []) do
    %{gap_limit_stop: gap_limit_stop} = Enum.into(opts, @get_book_entries_defaults)

    xpub
    |> XpubManager.entries_for(gap_limit_stop)
    |> JournalReport.from_entries()
  end

  def get_address_history(address) do
    address
    |> AddressManager.history_for()
    |> Map.get(:history)
    |> Enum.map(fn history_item ->
      JournalReport.from_transaction_request(history_item, address)
    end)
  end

  def get_utxos(xpub) do
    xpub
    |> AddressGenerator.until_gap(@gap_limit, &get_utxos_from_electrum_server/1)
    |> remove_empty_addresses
  end

  defp get_utxos_from_electrum_server(%AddressInfo{address: address}) do
    ElectrumClient.list_unspent(address)
  end

  defp remove_empty_addresses(addresses_with_utxos) do
    addresses_with_utxos
    |> Enum.filter(fn {_address_info, utxo_list} ->
      Enum.count(utxo_list) > 0
    end)
  end
end
