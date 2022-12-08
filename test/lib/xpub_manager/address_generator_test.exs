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

  test "test returning self with gap limit of one" do
    gap_limit = 1

    result =
      AddressGenerator.until_gap(@xpub, gap_limit, fn %AddressInfo{address: address} ->
        get_data(address)
      end)

    assert [
             {%AddressInfo{address: "mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L"}, ["mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L"]},
             {%AddressInfo{address: "myM8AfdxbgYyHnawSXwyfWC2zC9ZK4MhMW"}, []},
             {%AddressInfo{address: "mvyJx7fu7Xgi5ESqk1EjMxZ19cwdSD1tWC"}, ["mvyJx7fu7Xgi5ESqk1EjMxZ19cwdSD1tWC"]},
             {%AddressInfo{address: "mfjtqTDHvxHNVqE8RAKVjaQawCyqqxMgV8"}, []}
           ] = result
  end

  defp get_data("mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L"), do: ["mwYKDe7uJcgqyVHJAPURddeZvM5zBVQj5L"]
  defp get_data("myM8AfdxbgYyHnawSXwyfWC2zC9ZK4MhMW"), do: []
  defp get_data("msrNQRYrHbv86vLPcMxTT3NEuHfSgHmdmy"), do: []
  defp get_data("mvyJx7fu7Xgi5ESqk1EjMxZ19cwdSD1tWC"), do: ["mvyJx7fu7Xgi5ESqk1EjMxZ19cwdSD1tWC"]
  defp get_data("mfjtqTDHvxHNVqE8RAKVjaQawCyqqxMgV8"), do: []
  defp get_data("mnwWzsQ4a15kNjDB5cRD66A7m5sKSrU2kd"), do: []
end
