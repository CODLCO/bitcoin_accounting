defmodule BitcoinAccounting.JournalEntries do
  alias BitcoinLib.Transaction
  alias BitcoinLib.Key.Address
  alias BitcoinAccounting.JournalEntries.OutputManager

  @spec from_transaction(%Transaction{}, binary()) :: map()
  def from_transaction(%Transaction{} = transaction, address) do
    extracted =
      %{transaction: transaction, address: address}
      |> extract_inputs()
      |> extract_outputs()
      |> classify_inputs()
      |> classify_outputs()
      |> filter_inputs()
      |> filter_outputs()
      |> create_debits()
      |> create_credits()

    %{
      txid: extracted.transaction.id,
      credits: extracted.credits,
      debits: extracted.debits
    }
  end

  defp extract_inputs(%{transaction: %Transaction{inputs: inputs}} = hash) do
    inputs =
      inputs
      |> Enum.map(fn input ->
        input.txid
        |> ElectrumClient.get_transaction()
        |> Map.get(:outputs)
        |> Enum.at(input.vout)
      end)

    Map.put(hash, :inputs, inputs)
  end

  defp extract_outputs(%{transaction: transaction} = hash) do
    outputs =
      transaction
      |> Map.get(:outputs)

    Map.put(hash, :outputs, outputs)
  end

  defp classify_inputs(%{inputs: inputs, address: address} = hash) do
    %{hash | inputs: classify(inputs, address)}
  end

  defp classify_outputs(%{outputs: outputs, address: address} = hash) do
    %{hash | outputs: classify(outputs, address)}
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

  defp filter_inputs(%{inputs: inputs, address: address} = hash) do
    %{hash | inputs: Enum.filter(inputs, &(&1.address == address))}
  end

  defp filter_outputs(%{outputs: outputs, address: address} = hash) do
    %{hash | outputs: Enum.filter(outputs, &(&1.address == address))}
  end

  defp create_debits(%{inputs: inputs} = hash) do
    Map.put(hash, :debits, Enum.map(inputs, & &1.value))
  end

  defp create_credits(%{outputs: outputs} = hash) do
    Map.put(hash, :credits, Enum.map(outputs, & &1.value))
  end
end
