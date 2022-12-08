defmodule BitcoinAccounting.XpubManager.AddressGeneratorTest do
  use ExUnit.Case, async: true

  alias BitcoinAccounting.XpubManager.{AddressGenerator, AddressInfo}

  doctest AddressGenerator

  @xpub "tpubDDJMFT1RGo7pAQxLSFSawLMBJGVizgq4Ny9hYmHWJCYTDW6JsGu3ZqU1RBVPJFhMJjr44fcdeny3uRjQmtUsH1dtuTQG9Ni29AHGwYK56Zq"

  test "test a 2 gap limit generator, must return 2 empties each for receive and change, 4 in total" do
    gap_limit = 2

    result =
      AddressGenerator.until_gap(@xpub, gap_limit, fn %AddressInfo{} ->
        []
      end)

    assert 4 = Enum.count(result)
  end
end
