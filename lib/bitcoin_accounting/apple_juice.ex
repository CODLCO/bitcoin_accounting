defmodule BitcoinAccounting.AppleJuice do
  alias BitcoinAccounting.XpubManager.AddressRange
  alias BitcoinAccounting.AddressManager.JournalEntries.OutputManager
  alias BitcoinLib.Address

  @electrum_client Application.compile_env!(:bitcoin_accounting, :electrum_client)

  def report(xpub, gap_limit_stop) do
    changes = raw_change_entries(xpub, gap_limit_stop)

    receives = raw_receive_entries(xpub, gap_limit_stop)

    Enum.map(receives, fn rcv -> to_entries(rcv, changes) end)
  end

  def raw_change_entries(xpub, gap_limit_stop) do
    xpub
    |> scan_xpub([], gap_limit_stop, true)
    |> Enum.reject(&(&1.history == []))
  end

  def raw_receive_entries(xpub, gap_limit_stop) do
    xpub
    |> scan_xpub([], gap_limit_stop, false)
    |> Enum.reject(&(&1.history == []))
  end

  defp scan_xpub(xpub, previous_entries, gap_limit_stop, change?) do
    scanning_range = range_to_scan(previous_entries, gap_limit_stop)

    new_entries =
      xpub
      |> AddressRange.get_address_range(change?, scanning_range)
      |> history_for()

    entries = previous_entries ++ new_entries

    reached_gap_limit? = Enum.all?(new_entries, &Enum.empty?(&1.history))

    if reached_gap_limit? do
      entries
    else
      scan_xpub(xpub, entries, gap_limit_stop, change?)
    end
  end

  defp range_to_scan(previous_entries, gap_limit_stop) do
    previous_entries_count = Enum.count(previous_entries)
    previous_entries_count..(previous_entries_count + gap_limit_stop - 1)
  end

  def history_for(address_range) when is_list(address_range) do
    Enum.map(address_range, &history_for/1)
  end

  def history_for(address) when is_binary(address) do
    history =
      address
      |> ElectrumClient.get_address_history()
      |> Enum.map(fn %{txid: transaction_id} ->
        transaction_id
        |> ElectrumClient.get_transaction()
        |> Map.put(:tx_id, transaction_id)
      end)

    %{address: address, history: history}
  end

  # ----  Interpreting  ---- #

  def to_entries(rcv, changes) do
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
            fee: fee(ops)
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
    |> extract_inputs()
    |> classify(address)
    |> Enum.reduce([], fn input, acc ->
      if input.address == address or input.address in change_addresses(changes) do
        operation = %{
          direction: :send,
          value: input.value,
          address: input.address
        }

        [operation | acc]
      else
        acc
      end
    end)
  end

  def output_operations(transaction, address, changes) do
    transaction
    |> Map.get(:outputs)
    |> classify(address)
    |> Enum.reduce([], fn output, acc ->
      type =
        if output.address == address or output.address in change_addresses(changes) do
          :self
        else
          :external
        end

      operation = %{
        direction: :receive,
        value: output.value,
        address: output.address,
        type: type
      }

      [operation | acc]
    end)
  end

  defp extract_inputs(transaction) do
    transaction
    |> Map.get(:inputs)
    |> Enum.map(fn input ->
      input
      |> Map.get(:txid)
      |> @electrum_client.get_transaction()
      |> Map.get(:transaction)
      |> Map.get(:outputs)
      |> Enum.at(input.vout)
    end)
  end

  # movement is either inputs or outputs
  def classify(movements, address) do
    {:ok, _, _key_type, network} = Address.destructure(address)

    movements
    |> Enum.map(fn movement ->
      {script_type, script_value, address} = OutputManager.identify_script_type(movement, network)

      movement
      |> Map.put(:script_type, script_type)
      |> Map.put(:script_value, script_value)
      |> Map.put(:address, address)
    end)
  end

  def change_addresses(changes) do
    Enum.map(changes, & &1.address)
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
