defmodule BitcoinAccounting.XpubManager.AddressTest do
  use ExUnit.Case, async: true

  alias BitcoinAccounting.XpubManager.Address

  @receive false
  @change true

  test "get the first receive address from an xpub" do
    xpub =
      "tpubDDJMFT1RGo7pAQxLSFSawLMBJGVizgq4Ny9hYmHWJCYTDW6JsGu3ZqU1RBVPJFhMJjr44fcdeny3uRjQmtUsH1dtuTQG9Ni29AHGwYK56Zq"

    address = Address.from_xpub(xpub, @receive, 0)

    assert %{address: "mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L", change?: false, index: 0} == address
  end

  test "get the second change address from an xpub" do
    xpub =
      "tpubDDJMFT1RGo7pAQxLSFSawLMBJGVizgq4Ny9hYmHWJCYTDW6JsGu3ZqU1RBVPJFhMJjr44fcdeny3uRjQmtUsH1dtuTQG9Ni29AHGwYK56Zq"

    address = Address.from_xpub(xpub, @change, 1)

    assert %{address: "mfjtqTDHvxHNVqE8RAKVjaQawCyqqxMgV8", change?: true, index: 1} == address
  end
end
