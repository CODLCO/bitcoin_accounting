defmodule BitcoinAccounting.XpubManager.AddressGenerator.State do
  @moduledoc """
  A struct simplifiying the AddressGenerator's loop

  Contains:

  xpub: an xpub
  receive_or_change: either false for receive addresses, or true for change addresses
  counter: a tuple containing both the empty address count and the gap limit
  current_index: the last part of a derivation path
  accumulator: keeps whatever manage_address returns in a list
  """

  defstruct [:xpub, :change?, :counter, :current_index, :manage_address, :accumulator]
end
