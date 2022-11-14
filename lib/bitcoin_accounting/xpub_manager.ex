defmodule BitcoinAccounting.XpubManager do
  alias BitcoinAccounting.XpubManager.AddressRange
  alias BitcoinAccounting.AddressManager

  def entries_for(xpub, gap_limit_stop) do
    %{
      change: change_entries(xpub, gap_limit_stop),
      receive: receive_entries(xpub, gap_limit_stop)
    }
  end

  defp change_entries(xpub, gap_limit_stop) do
    scan(xpub, [], gap_limit_stop, true)
  end

  defp receive_entries(xpub, gap_limit_stop) do
    scan(xpub, [], gap_limit_stop, false)
  end

  defp scan(xpub, previous_entries, gap_limit_stop, change?) do
    scanning_range = range_to_scan(previous_entries, gap_limit_stop)

    new_entries =
      xpub
      |> AddressRange.get_address_range(change?, scanning_range)
      |> AddressManager.history_for()

    entries = previous_entries ++ new_entries

    reached_gap_limit? = Enum.all?(new_entries, &Enum.empty?(&1.history))

    if reached_gap_limit? do
      entries
    else
      scan(xpub, entries, gap_limit_stop, change?)
    end
  end

  defp range_to_scan(previous_entries, gap_limit_stop) do
    previous_entries_count = Enum.count(previous_entries)
    previous_entries_count..(previous_entries_count + gap_limit_stop - 1)
  end
end
