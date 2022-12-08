defmodule BitcoinAccounting.XpubManager.AddressGenerator do
  @moduledoc """
  Loops on an xpub to create addresses up until a certain threshold is met
  """

  @receive false
  @change true

  @initial_count 0
  @initial_index 0
  @initial_data []

  alias BitcoinAccounting.XpubManager.AddressInfo
  alias BitcoinAccounting.XpubManager.AddressGenerator.State

  @doc """
  Loops on an xpub to create addresses up until a certain threshold is met,
  executing the manage_address function for each address in the process
  """
  @spec until_gap(binary(), integer(), function()) :: list({%AddressInfo{}, list()})
  def until_gap(xpub, gap_limit, manage_address) do
    [@receive, @change]
    |> Enum.map(&loop(xpub, &1, gap_limit, manage_address))
    |> Enum.concat()
  end

  defp loop(xpub, change?, gap_limit, manage_address) do
    %State{
      xpub: xpub,
      change?: change?,
      counter: {@initial_count, gap_limit},
      current_index: @initial_index,
      manage_address: manage_address,
      accumulator: @initial_data
    }
    |> loop
  end

  # loop exit strategy, when the gap limit has been reached
  defp loop(%State{counter: {empty_count, gap_limit}, accumulator: accumulator})
       when empty_count == gap_limit do
    accumulator
  end

  defp loop(%State{counter: {empty_count, gap_limit}, current_index: index} = state) do
    with {:ok, address_info} <- AddressInfo.from_xpub(state.xpub, state.change?, index) do
      {empty_count, accumulator} =
        case state.manage_address.(address_info) do
          [] -> {empty_count + 1, [{address_info, []} | state.accumulator]}
          result -> {0, [{address_info, result} | state.accumulator]}
        end

      %{state | counter: {empty_count, gap_limit}, current_index: index + 1, accumulator: accumulator}
      |> loop
    else
      {:error, message} -> {:error, message}
    end
  end
end
