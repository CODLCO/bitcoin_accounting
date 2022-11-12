defmodule BitcoinAccounting.AddressManager do
  def history_for(address_range) when is_list(address_range) do
    Enum.map(address_range, &history_for/1)
  end

  def history_for(address) when is_binary(address) do
    address
    |> ElectrumClient.get_address_history()
    |> Enum.map(fn %{txid: transaction_id} ->
      transaction_id
      |> ElectrumClient.get_transaction()
      |> Map.put(:tx_id, transaction_id)
    end)
  end

  def extract_book_entries(address_range) when is_list(address_range) do
    address_range
    |> Enum.map(fn address ->
      extract_book_entries(address)
    end)
  end

  def extract_book_entries(address) when is_binary(address) do
    history = history_for(address)

    %{address: address, history: history}
  end
end
