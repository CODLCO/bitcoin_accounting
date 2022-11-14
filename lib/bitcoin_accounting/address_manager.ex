defmodule BitcoinAccounting.AddressManager do
  def history_for(address_range) when is_list(address_range) do
    Enum.map(address_range, &history_for/1)
  end

  def history_for(address) when is_binary(address) do
    history =
      address
      |> electrum_client().get_address_history()
      |> Enum.map(fn %{txid: transaction_id} ->
        transaction_id
        |> electrum_client().get_transaction()
        |> Map.put(:tx_id, transaction_id)
      end)

    %{address: address, history: history}
  end

  defp electrum_client() do
    Application.get_env(:bitcoin_accounting, :electrum_client)
  end
end
