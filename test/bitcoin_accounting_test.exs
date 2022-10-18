defmodule BitcoinAccountingTest do
  use ExUnit.Case
  doctest BitcoinAccounting

  test "greets the world" do
    assert BitcoinAccounting.hello() == :world
  end
end
