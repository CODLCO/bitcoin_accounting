defmodule BitcoinAccounting.AddressManager.JournalEntries do
  alias BitcoinLib.Transaction
  alias BitcoinAccounting.AddressManager

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
    |> AddressManager.classify(address)
    |> filter_address(address)
    |> get_value()
  end

  defp get_credits(transaction, address) do
    transaction
    |> extract_outputs()
    |> AddressManager.classify(address)
    |> filter_address(address)
    |> get_value()
  end

  defp extract_inputs(transaction) do
    Enum.map(transaction.inputs, & &1.vout_details)
  end

  defp extract_outputs(transaction) do
    Map.get(transaction, :outputs)
  end

  defp filter_address(inputs, address) do
    Enum.filter(inputs, &(&1.address == address))
  end

  defp get_value(inputs) do
    Enum.map(inputs, & &1.value)
  end
end
