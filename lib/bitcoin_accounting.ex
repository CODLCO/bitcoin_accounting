defmodule BitcoinAccounting do
  alias BitcoinAccounting.{AddressManager, XpubManager}

  @get_book_entries_defaults %{empty_address_count: 20}

  @spec get_book_entries(binary()) :: list()
  def get_book_entries(xpub, opts \\ []) do
    %{empty_address_count: empty_address_count} = Enum.into(opts, @get_book_entries_defaults)

    %{
      receive: XpubManager.get_receive_entries(xpub, empty_address_count),
      change: XpubManager.get_change_entries(xpub, empty_address_count)
    }
  end

  def get_address_history(address) do
    AddressManager.get_history(address)
  end
end
