defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressManager, XpubManager}
  alias BitcoinAccounting.JournalReport

  @change? true
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
    |> XpubManager.map_addresses(!@change?, fn address, empties ->
      case ElectrumClient.list_unspent(address) do
        [] ->
          if empties < @gap_limit do
            {:continue, nil, empties + 1}
          else
            {:stop}
          end

        utxos ->
          {:continue, utxos, 0}
      end
    end)
    |> IO.inspect()
  end

  # defp load_transactions(utxos) do
  #   utxos
  #   |> Enum.map(fn utxo = %{transaction_id: txid} ->
  #     IO.inspect(txid)
  #     %{utxo | transaction: ElectrumClient.get_transaction(txid)}
  #   end)
  # end
end
