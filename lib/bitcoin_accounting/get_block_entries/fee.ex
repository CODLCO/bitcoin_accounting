defmodule BitcoinAccounting.GetBlockEntries.Fee do
  alias BitcoinLib.Transaction
  alias BitcoinLib.Transaction.{Input, Output}

  def from_transaction_id(id) do
    %{transaction: transaction} = ElectrumClient.get_transaction(id)

    inputs_value = get_inputs_value(transaction)
    outputs_value = get_outputs_value(transaction)

    inputs_value - outputs_value
  end

  def get_inputs_value(%Transaction{inputs: inputs}) do
    inputs
    |> Enum.reduce(0, fn %Input{} = input, value ->
      %Output{} = output = ElectrumClient.get_transaction_output(input.txid, input.vout)

      value + output.value
    end)
  end

  def get_outputs_value(%Transaction{outputs: outputs}) do
    outputs
    |> Enum.reduce(0, fn %Output{} = output, value ->
      value + output.value
    end)
  end
end
