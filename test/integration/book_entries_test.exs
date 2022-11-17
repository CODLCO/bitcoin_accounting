defmodule BitcoinAccounting.Integration.BookEntriesTest do
  use ExUnit.Case, async: false

  setup do
    Application.put_env(:bitcoin_accounting, :electrum_client, ElectrumClient)

    on_exit(fn ->
      Application.put_env(:bitcoin_accounting, :electrum_client, ElectrumClientMock)
    end)

    ip = System.fetch_env!("LB_ELECTRUM_CLIENT_IP") |> IO.inspect()
    port = System.fetch_env!("LB_ELECTRUM_CLIENT_PORT") |> Integer.parse() |> elem(0)

    start_supervised!(%{
      id: ElectrumClient,
      start: {ElectrumClient, :start_link, [ip, port]}
    })

    :ok
  end

  describe "BitcoinAccounting.get_book_entries/1" do
    @tag :integration
    test "returns book entries" do
      entries =
        BitcoinAccounting.get_book_entries(
          "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8"
        )

      assert %{
               change: [
                 %{address: "1NwEtFZ6Td7cpKaJtYoeryS6avP2TUkSMh", history: []},
                 %{address: "18FcseQ86zCaXzLbgDsH86292xb2EuKtFW", history: []},
                 %{address: "1NZ97rKhSPy6NLud5Dp89E4yH5a2fUGeyC", history: []},
                 %{address: "1GtD6J3DK1SrZu7bqMt1VKGNjhFap7t5Ku", history: []},
                 %{address: "1NitxAxJLdYgJTL5YwKd3N6pD2LPcE8wSY", history: []},
                 %{address: "1LWYcEi1bUMfiCoXJwTXF4q8iRGnqhb8jr", history: []},
                 %{address: "1CEiPmWCaeBboowrPbzBGQtv7SGHGXWbPR", history: []},
                 %{address: "1EtKXtGgnM9oEJThrNDFLjJQpk1fktgjNc", history: []},
                 %{address: "15HkjCP4PwkJqjQ9GVyngEFrEgujan93qz", history: []},
                 %{address: "1eWNxfQVi6wRti9qqsDPQ9pqZqebpXxwF", history: []},
                 %{address: "19r9h32Lr2stSynHkk3yrqZ4VvdnERMxJZ", history: []},
                 %{address: "1NsqgAXszYxNyARKm4E5wEUBjapnMZhaq7", history: []},
                 %{address: "13rZTrjvfsGvZV1EoJ5PLVShLG2r9gEHkm", history: []},
                 %{address: "14vQDPotrcT4cJ4uyXaj9ZtrKREV1MupqU", history: []},
                 %{address: "1HzBqvxEw2rVVw4vGgi8MGtwCZVDjDh642", history: []},
                 %{address: "15cqFniQx2ojWWi2GTKKGUAi6ShsLKXKV3", history: []},
                 %{address: "1EHjziiCcK796GneHXyMH51KTQ6UegzSBo", history: []},
                 %{address: "1JNVQsSHZjAqXDqgFDZEqL5fCxSk8m5cHE", history: []},
                 %{address: "19S2QYjvU6AUpkizuRSpnJi2EK2e6hhGnX", history: []},
                 %{address: "1M3eTqjXY4gKDJT8D63b7abTGeZjiYVHGZ", history: []}
               ],
               receive: [
                 %{
                   address: "12CL4K2eVqj7hQTix7dM7CVHCkpP17Pry3",
                   history: [
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
                   ]
                 },
                 %{address: "13Q3u97PKtyERBpXg31MLoJbQsECgJiMMw", history: []},
                 %{address: "1J4LVanjHMu3JkXbVrahNuQCTGCRRgfWWx", history: []},
                 %{address: "1EBPs7ApVkRNy9Y8Z8xLAueeH4wuD1Aixb", history: []},
                 %{address: "1H2RCEj5KFAxY4TvibjKivf8sPipZA62CF", history: []},
                 %{address: "1K6rDJZ54hn4XouChMSp1zcZN5vniP2fzw", history: []},
                 %{address: "1MGxajmnvNKW84o72fRynwzrDXj7htJYBo", history: []},
                 %{address: "1H4STVrrTCPR6qiL7qFUXq97CBr3DHPwxD", history: []},
                 %{address: "1JLhjtQ9E5GyT9HARXc3xFxD9pYvgLzVU2", history: []},
                 %{
                   address: "15MbJzwHGPq5ETKLBp3yPHoxQ5GUB9avyS",
                   history: [
                     %{
                       confirmations: _,
                       credits: [50000],
                       debits: [],
                       time: ~U[2015-02-13 00:37:09Z],
                       txid: "afdbc8e98cbf58e754e75d4b70ec223a0c4d207dfa8648b4c35bfa83a89436a2"
                     },
                     %{
                       confirmations: _,
                       credits: [],
                       debits: [50000],
                       time: ~U[2015-02-13 00:43:40Z],
                       txid: "a2cddaa03c98c6e8c439b75b510a575884f1c6b82b727149f0758eb920454514"
                     }
                   ]
                 },
                 %{address: "17fz4VHcFtJxS4GNoM2AkY76ZXkPUXUKXy", history: []},
                 %{address: "1KgnZTQTagyR7j6quqFnQAecUooPoTZx9K", history: []},
                 %{address: "17PmXRcXGxBXWWhqJeB94cfwbPmy1x9fN", history: []},
                 %{address: "1JgcEGhuFg4Aofmd6HbhCvxBXTPnSY6tXw", history: []},
                 %{address: "1G93sV7huAgSBfzzxi5eTeyq2VXL2MogBS", history: []},
                 %{address: "1LHcicpV6MZQDzZFE2ufDgDcAKUS9RGZSM", history: []},
                 %{address: "1PxLR3iTrEVDCjXGaRnf9bGb9FLMMmWH71", history: []},
                 %{address: "13iVwijHjo59m6HEYzDGM9U7U6pkVwPo83", history: []},
                 %{address: "1PDDAS6aCukFMnveYPDX1EbdxU5syfpEhk", history: []},
                 %{address: "1Db133X5JXnw5fcadHLC84RYRZw8RYrVc3", history: []},
                 %{address: "15gFhS5AXYfWe8BuorRFT3tqmfgxiJJs1T", history: []},
                 %{address: "1FDbCxVK5B3PwpLSQMhHyEJkWUVQXmLsPf", history: []},
                 %{
                   address: "16nWB7Si2hTUtqi71dXtFBreScGWfhyNnm",
                   history: [
                     %{
                       confirmations: _,
                       credits: [100_000],
                       debits: [],
                       time: ~U[2013-07-14 04:00:52Z],
                       txid: "36b92e05aa5aeb4ca09393185b49a558cdad8870c0e0e53b3e041d95628a9761"
                     },
                     %{
                       confirmations: _,
                       credits: [],
                       debits: [100_000],
                       time: ~U[2013-07-14 04:34:59Z],
                       txid: "a6440fa095fcaed2a1d6c35200f5613de338053dccb5b6a5f8b2a5b1e2f9e0ee"
                     }
                   ]
                 },
                 %{address: "1Fd8CW7KVjuL3U28WKCVf7AJyrrczg5tdB", history: []},
                 %{
                   address: "1JEYhhAGC2JkLJhdnC1tWk2CtH64sX2Ur8",
                   history: [
                     %{
                       confirmations: _,
                       credits: [110_000],
                       debits: [],
                       time: ~U[2013-07-14 05:57:54Z],
                       txid: "ca1910e01ed32e7a9408b7e9e99f39bd4ef6be1911a1fb5a3d5533fa01f61df6"
                     },
                     %{
                       confirmations: _,
                       credits: [],
                       debits: [110_000],
                       time: ~U[2013-07-14 06:18:53Z],
                       txid: "884a2eb058b4360cbc5a4fa8131f3e0ec34aff5c635e34feb3c457d12d0bc93d"
                     },
                     %{
                       confirmations: _,
                       credits: [67396],
                       debits: [],
                       time: ~U[2018-02-13 13:52:16Z],
                       txid: "a0a7e1bb6460bffed958bc80d74966be14fdec09608408de351053d1e8d653a1"
                     },
                     %{
                       confirmations: _,
                       credits: [],
                       debits: [67396],
                       time: ~U[2018-02-13 14:29:00Z],
                       txid: "b62aa5203fa27495ea431b91a5090aab741c8c39cc03ec4c1f4f4e157507595f"
                     }
                   ]
                 },
                 %{address: "1Fi9enFgWBaj1rbBeMo687DQqhkfeP6PuE", history: []},
                 %{address: "1LuXPj5WCbABndfc8VHUubVVrn5vrBLtGd", history: []},
                 %{address: "1NJPWgsZSEHSasG1Jt4VakkTznW1GggDM5", history: []},
                 %{address: "1BD2HuuXMYfL3FUfXTgvjPqMxKxTk4uLW4", history: []},
                 %{address: "1L4TJAcK4HB4bLsXyLUMPavzvTnG5mAwEY", history: []},
                 %{address: "1Ephi3U2fvxnxz9CrdLeoZ22LKQqLdN2NV", history: []},
                 %{address: "17HCQvdgQ5MVq5m8KrgqRjUQ1YJjvTVwx2", history: []},
                 %{address: "17W3eLwcRMCafga9a4aLQu13YoCK6jp9bY", history: []},
                 %{address: "18D5AtedNHs9maLibmAmGdBq1W57fsHdFL", history: []},
                 %{address: "1GXdxseg7vgPJFgysp4Jg9P2TkfwSXJ5cm", history: []},
                 %{address: "1DhujbhjZXkF6cHr46Ae6i8XYpURxAFzy", history: []},
                 %{address: "1EYsTLN1stGsh8yKh6k7cceBcfaDtHiJp4", history: []},
                 %{address: "1LkHs8tDbyKmed9eST9GGbMZGeBvzGMzGy", history: []},
                 %{address: "1Nsdbvu3m6Q1n54tZEsZ8zqmN697UKJW6j", history: []},
                 %{address: "1P2dvQmvEdJwk7DZ1kKs9RUzCFTxynZZ3n", history: []},
                 %{address: "1MZWAzbf6kSDakRQCJNHa3tGxFt1Z7nguD", history: []},
                 %{address: "1MCFteeFEvmvYDssqLUZjMNyzGG67QnJPt", history: []},
                 %{address: "132mu6q9bx52RUbM83o1AtqAmaswFZZMyD", history: []},
                 %{address: "15VfCY3FZep23n8z3GTtXMHzaL39oZLY34", history: []},
                 %{address: "15VLWiNeGTuqyBejhrarLr9K6DuxJ83XZi", history: []},
                 %{address: "1K4BXWK95Mkhe9z59nEwZtneBbjD9xFC5L", history: []},
                 %{address: "1KyndbvmxBCqZTNZBZNbUSuXwTaaThrDsh", history: []},
                 %{address: "1MLLW62YFNDa1665ZvXUc5k2LBbWaHBzWw", history: []},
                 %{address: "122zPJky3ZeHAHVjSisHvPQYXNEoNNoNT3", history: []},
                 %{address: "1Q8x3Zssk1Xhq2uWod9GpMZfqeS6HeBLCW", history: []},
                 %{address: "1BK4QAEQnY2UKtUdDz3kLyigYg3cjmycHb", history: []},
                 %{address: "199n3HmvhFC34hbkEXcSbmT1dYh8bpj3DM", history: []},
                 %{address: "1Kw6o2J9QGtrTisiJhZZnGKo1ULMizqXHX", history: []},
                 %{address: "17YuoQ5Sw8qK2fKbZ49jyMEKndJNJxynsp", history: []},
                 %{address: "1PKxvoPFKjkWdnhFnxTArcF1DHnMCtnb3y", history: []},
                 %{address: "1KzXsk6z2ea2x9Q3ZU7TK3DKaucYZDrdA8", history: []},
                 %{address: "12yGa36WUxY7prVv3rZTNN6GDxU2AAX9w7", history: []},
                 %{address: "12rwnn74yZejpQL7yrnT4oHQnNPUSdn5eQ", history: []},
                 %{address: "18p9HLmb869SECTiHpAvhuPdV3AV1VFy3C", history: []},
                 %{address: "16fYQGY4CgQqkgjerDKE878PZr6Um4Y9PR", history: []}
               ]
             } = entries

      assert confirmations > 480_622
      history_item = hd(hd(entries.receive).history)
      assert Map.keys(history_item) == [:confirmations, :credits, :debits, :time, :txid]
    end
  end
end
