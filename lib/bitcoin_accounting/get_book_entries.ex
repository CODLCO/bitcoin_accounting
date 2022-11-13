defmodule BitcoinAccounting.GetBookEntries do
  @execute_defaults %{empty_address_count: 20}

  alias BitcoinAccounting.XpubManager

  @spec from_xpub(binary(), list()) :: list()
  def from_xpub(xpub, opts \\ []) do
    %{empty_address_count: empty_address_count} = Enum.into(opts, @execute_defaults)

    receive_entries =
      XpubManager.get_receive_entries(xpub, empty_address_count)
      |> flatten(:receive)

    change_entries =
      XpubManager.get_change_entries(xpub, empty_address_count)
      |> flatten(:change)

    (receive_entries ++ change_entries)
    #    |> sort()
    |> group_by_txid()
  end

  defp flatten(entries, receive_or_change) do
    entries
    |> Enum.map(fn entry -> to_new_structure(entry, receive_or_change) end)
    |> Enum.concat()
  end

  defp to_new_structure(entry, receive_or_change) do
    entry.history
    |> Enum.map(fn history ->
      history
      |> Map.put(:type, receive_or_change)
      |> Map.put(:address, entry.address)
    end)
  end

  # defp sort(entries) do
  #   entries
  #   |> Enum.sort(&(&1.time >= &2.time))
  # end

  defp group_by_txid(entries) do
    entries
    |> Enum.group_by(&Map.get(&1, :txid))
  end
end
