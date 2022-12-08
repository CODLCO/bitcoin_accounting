defmodule BitcoinAccounting.XpubManager.AddressInfoTest do
  use ExUnit.Case, async: true

  alias BitcoinAccounting.XpubManager.AddressInfo

  doctest AddressInfo

  @receive false
  @change true

  @xpub "tpubDDJMFT1RGo7pAQxLSFSawLMBJGVizgq4Ny9hYmHWJCYTDW6JsGu3ZqU1RBVPJFhMJjr44fcdeny3uRjQmtUsH1dtuTQG9Ni29AHGwYK56Zq"

  test "get the first receive address from an xpub" do
    {:ok, address} = AddressInfo.from_xpub(@xpub, @receive, 0)

    assert %AddressInfo{address: "mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L", change?: false, index: 0} == address
  end

  test "get the second change address from an xpub" do
    {:ok, address} = AddressInfo.from_xpub(@xpub, @change, 1)

    assert %AddressInfo{address: "mfjtqTDHvxHNVqE8RAKVjaQawCyqqxMgV8", change?: true, index: 1} == address
  end

  test "attempt to get an address with a negative index" do
    result = AddressInfo.from_xpub(@xpub, @receive, -1)

    assert {:error, "the index must not be a negative integer"} = result
  end

  test "attempt to get an address from an invalid xpub" do
    xpub = "abc"

    result = AddressInfo.from_xpub(xpub, @receive, 0)

    assert {:error, "unknown pub key serialization format"} = result
  end
end
