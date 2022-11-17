defmodule BitcoinAccounting.AddressManager do
  alias BitcoinLib.Address
  alias BitcoinAccounting.AddressManager.OutputManager

  def history_for(address_range) when is_list(address_range) do
    Enum.map(address_range, &history_for/1)
  end

  def history_for(address) when is_binary(address) do
    history =
      address
      |> electrum_client().get_address_history()
      |> Enum.map(fn %{txid: transaction_id} ->
        el_transaction =
          transaction_id
          |> electrum_client().get_transaction()
          |> Map.put(:tx_id, transaction_id)

        Map.put(el_transaction, :transaction, add_vouts(el_transaction.transaction, address))
      end)

    %{address: address, history: history}
  end

  defp add_vouts(transaction, address) do
    Map.put(
      transaction,
      :inputs,
      Enum.map(transaction.inputs, fn input ->
        vout =
          input
          |> Map.get(:txid)
          |> electrum_client().get_transaction()
          |> Map.get(:transaction)
          |> Map.get(:outputs)
          |> Enum.at(input.vout)

        Map.put(input, :vout_details, hd(classify([vout], address)))
      end)
    )
  end

  def classify(outputs, address) do
    {:ok, _, _key_type, network} = Address.destructure(address)

    outputs
    |> Enum.map(fn output ->
      {script_type, script_value, address} = OutputManager.identify_script_type(output, network)

      output
      |> Map.put(:script_type, script_type)
      |> Map.put(:script_value, script_value)
      |> Map.put(:address, address)
    end)
  end

  defp electrum_client() do
    Application.get_env(:bitcoin_accounting, :electrum_client)
  end
end
