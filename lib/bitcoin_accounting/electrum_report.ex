defmodule BitcoinAccounting.ElectrumReport do
  alias BitcoinAccounting.XpubManager
  alias BitcoinAccounting.AddressManager

  def for(xpub, gap_limit_stop \\ 20) do
    %{change: changes, receive: receives} = XpubManager.entries_for(xpub, gap_limit_stop)

    Enum.map(receives, fn rcv -> to_entries(rcv, receives, changes) end)
  end

  defp to_entries(rcv, receives, changes) do
    %{
      address: rcv.address,
      entries:
        Enum.map(rcv.history, fn entry_history ->
          ops = operations(entry_history, rcv.address, changes)

          %{
            txid: entry_history.tx_id,
            time: entry_history.time,
            confirmations: entry_history.confirmations,
            operations: ops,
            fee: fee(ops),
            sent_by: sent_by(entry_history, receives, changes)
          }
        end)
    }
  end

  def operations(entry_history, address, changes) do
    input_operations(entry_history.transaction, address, changes) ++
      output_operations(entry_history.transaction, address, changes)
  end

  def input_operations(transaction, address, changes) do
    transaction
    |> Map.get(:inputs)
    |> then(fn inputs ->
      Enum.map(inputs, &{&1, hd(AddressManager.classify([&1.vout_details], address))})
    end)
    |> Enum.reduce([], fn {_input, output}, acc ->
      operation = %{
        direction: :send,
        value: output.value,
        address: output.address,
        type: operation_type(output, changes, address)
      }

      [operation | acc]
    end)
  end

  def output_operations(transaction, address, changes) do
    transaction
    |> Map.get(:outputs)
    |> AddressManager.classify(address)
    |> Enum.reduce([], fn output, acc ->
      operation = %{
        direction: :receive,
        value: output.value,
        address: output.address,
        type: operation_type(output, changes, address)
      }

      [operation | acc]
    end)
  end

  def operation_type(output, changes, address) do
    if output.address == address or output.address in addresses_in(changes) do
      :self
    else
      :external
    end
  end

  def sent_by(entry_history, receives, changes) do
    sender_addresses = Enum.map(entry_history.transaction.inputs, & &1.vout_details.address)

    my_inputs =
      Enum.any?(sender_addresses, fn sender_address ->
        sender_address in addresses_in(changes) or sender_address in addresses_in(receives)
      end)

    if my_inputs do
      :myself
    else
      :external
    end
  end

  defp addresses_in(section) do
    Enum.map(section, & &1.address)
  end

  defp fee(ops) do
    if Enum.any?(ops, &(&1.direction == :send)) do
      ops
      |> Enum.map(&if(&1.direction == :send, do: &1.value * -1, else: &1.value))
      |> Enum.sum()
      |> abs()
    else
      nil
    end
  end
end
