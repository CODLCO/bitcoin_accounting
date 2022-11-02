defmodule BitcoinAccounting.XpubManager do
  alias BitcoinAccounting.XpubManager.AddressRange
  alias BitcoinAccounting.{AddressManager}

  def get_receive_entries(xpub, empty_address_request) do
    IO.puts("receive")
    get_entries(xpub, [], false, empty_address_request)
  end

  def get_change_entries(xpub, empty_address_request) do
    IO.puts("change")
    get_entries(xpub, [], true, empty_address_request)
  end

  defp get_entries(xpub, previous_entries, change?, empty_address_request) do
    previous_entries_count = Enum.count(previous_entries)

    range = previous_entries_count..(previous_entries_count + empty_address_request - 1)

    new_entries =
      xpub
      |> AddressRange.get_address_range(change?, range)
      |> AddressManager.extract_book_entries()

    entries = previous_entries ++ new_entries

    needs_more = !Enum.all?(new_entries, &Enum.empty?(&1.history))

    if needs_more do
      get_entries(xpub, entries, change?, empty_address_request)
    else
      entries
    end
  end
end
