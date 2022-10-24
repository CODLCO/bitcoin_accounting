defmodule BitcoinAccounting.JournalEntries do
  alias BitcoinLib.Transaction
  alias BitcoinLib.Key.Address
  alias BitcoinAccounting.JournalEntries.OutputManager

  @spec from_transaction(%Transaction{}, binary()) :: map()
  def from_transaction(%Transaction{} = transaction, address) do
    credits = get_credits(transaction, address)
    debits = get_debits(transaction, address)

    %{
      txid: transaction.id,
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
    transaction
    |> Map.get(:inputs)
    |> Enum.map(fn input ->
      input.txid
      |> ElectrumClient.get_transaction()
      |> Map.get(:outputs)
      |> Enum.at(input.vout)
    end)
  end

  defp extract_outputs(transaction) do
    Map.get(transaction, :outputs)
  end

  defp classify(outputs, address) do
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
