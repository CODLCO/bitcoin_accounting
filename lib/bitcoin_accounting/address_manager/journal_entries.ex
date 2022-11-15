defmodule BitcoinAccounting.AddressManager.JournalEntries do
  alias BitcoinLib.{Address, Transaction}
  alias BitcoinAccounting.AddressManager.JournalEntries.OutputManager

  def for_xpub(entries) do
    %{
      change: Enum.map(entries.change, &for_xpub_entry/1),
      receive: Enum.map(entries.receive, &for_xpub_entry/1)
    }
  end

  defp for_xpub_entry(%{address: address, history: history}) do
    %{
      address: address,
      history:
        Enum.map(history, fn history_item ->
          from_transaction_request(history_item, address)
        end)
    }
  end

  @spec from_transaction_request(map(), binary()) :: map()
  def from_transaction_request(
        %{
          block_hash: _block_hash,
          time: time,
          confirmations: confirmations,
          vsize: _vsize,
          transaction: %Transaction{} = transaction
        },
        address
      ) do
    credits = get_credits(transaction, address)
    debits = get_debits(transaction, address)

    %{
      txid: transaction.id,
      time: time,
      confirmations: confirmations,
      credits: credits,
      debits: debits
    }
  end

  defp get_debits(transaction, address) do
    transaction
    |> extract_inputs()
    |> classify(address)
    |> filter_address(address)
    |> get_value()
  end

  defp get_credits(transaction, address) do
    transaction
    |> extract_outputs()
    |> classify(address)
    |> filter_address(address)
    |> get_value()
  end

  defp extract_inputs(transaction) do
    Enum.map(transaction.inputs, & &1.vout_details)
  end

  defp extract_outputs(transaction) do
    Map.get(transaction, :outputs)
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

  defp filter_address(inputs, address) do
    Enum.filter(inputs, &(&1.address == address))
  end

  defp get_value(inputs) do
    Enum.map(inputs, & &1.value)
  end
end
