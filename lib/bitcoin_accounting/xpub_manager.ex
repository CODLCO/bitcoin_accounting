defmodule BitcoinAccounting.XpubManager do
  alias BitcoinAccounting.XpubManager.AddressRange
  alias BitcoinAccounting.{AddressManager}

  def get_receive_entries(xpub, empty_address_count) do
    get_entries(xpub, false, empty_address_count)
  end

  def get_change_entries(xpub, empty_address_count) do
    get_entries(xpub, true, empty_address_count)
  end

  defp get_entries(xpub, change?, empty_address_count) do
    xpub
    |> AddressRange.get_address_range(change?, 0..(empty_address_count - 1))
    |> AddressManager.extract_book_entries()
  end
end
