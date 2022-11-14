defmodule  BitcoinAccounting.Integration.AddressHistoryTest do
  use ExUnit.Case, async: false

  setup do
    Application.put_env(:bitcoin_accounting, :electrum_client, ElectrumClient)

    on_exit(fn ->
      Application.put_env(:bitcoin_accounting, :electrum_client, ElectrumClientMock)
    end)

    ip = System.fetch_env!("LB_ELECTRUM_CLIENT_IP")
    port = System.fetch_env!("LB_ELECTRUM_CLIENT_PORT") |> Integer.parse() |> elem(0)

    start_supervised!(%{
      id: ElectrumClient,
      start: {ElectrumClient, :start_link, [ip, port]}
    })

    :ok
  end

  describe "BitcoinAccounting.get_address_history/1" do
    @tag :integration
    test "returns address history" do
      history = BitcoinAccounting.get_address_history("12CL4K2eVqj7hQTix7dM7CVHCkpP17Pry3")

      assert [
               %{
                 confirmations: confirmations,
                 credits: [12822],
                 debits: [],
                 time: ~U[2014-01-24 23:23:12Z],
                 txid: "1b3aa619f7fee859eb78ead57fefb8f0ca0eba050f7a3cec072b5bdab1ebe910"
               },
               %{
                 confirmations: _,
                 credits: [],
                 debits: [12822],
                 time: ~U[2014-01-27 18:47:22Z],
                 txid: "a33bedac862a5f7cbe053e2342ed71a7ad9f93388789d32b0242d2020c977ddc"
               },
               %{
                 confirmations: _,
                 credits: [50000],
                 debits: [],
                 time: ~U[2015-02-13 15:50:42Z],
                 txid: "5df57e14b5cd1704f36723a9addc721c7eb9df6f67b32479bb0e6668d6d04f61"
               },
               %{
                 confirmations: _,
                 credits: [],
                 debits: [50000],
                 time: ~U[2015-02-13 16:55:20Z],
                 txid: "714b79953a6b7a0499d19196353eacbf47690a281b0998b0ff9981945e34a8d9"
               },
               %{
                 confirmations: _,
                 credits: [17936],
                 debits: [],
                 time: ~U[2015-07-17 16:22:20Z],
                 txid: "8615c3852c43074c1b335650ffe08428b0760bc30416f7a7ad8c90a01f77f4a5"
               },
               %{
                 confirmations: _,
                 credits: [],
                 debits: [17936],
                 time: ~U[2015-07-17 17:10:05Z],
                 txid: "536160170732da68c9744a22ef2a9196f44ac4877f9cf2fae9002823fbcfafbf"
               },
               %{
                 confirmations: _,
                 credits: [10000],
                 debits: [],
                 time: ~U[2016-01-23 01:22:55Z],
                 txid: "19a195d273b200976dc21f09808907f24c1c850ad7c7409992bac67fe85e4984"
               },
               %{
                 confirmations: _,
                 credits: [],
                 debits: [10000],
                 time: ~U[2016-01-23 08:07:23Z],
                 txid: "75a0de262c3922bc98b93b5b942d87c7834b48e9448120998e697e111f1e7811"
               }
             ] = history

      assert confirmations > 480_622
      assert Map.keys(hd(history)) == [:confirmations, :credits, :debits, :time, :txid]
    end
  end
end
