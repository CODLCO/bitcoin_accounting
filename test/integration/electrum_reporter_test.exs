defmodule BitcoinAccounting.ElectrumReporterTest do
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

  @tag :integration
  test "returns electrum-styled report" do
    assert [
             %{
               address: "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
               entries: [
                 %{
                   confirmations: confirmations,
                   fee: 143,
                   operations: [
                     %{
                       address: "bc1q4zyj34hmq0hqzg7sudq8evyfx4s8kpznpjtdcj",
                       direction: :send,
                       type: :external,
                       value: 66278
                     },
                     %{
                       address: "bc1q58sxp4tdynmhgtaxgu5fmweau70ng7jhumlf6z",
                       direction: :receive,
                       type: :external,
                       value: 6135
                     },
                     %{
                       address: "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
                       direction: :receive,
                       type: :self,
                       value: 60000
                     }
                   ],
                   sent_by: :external,
                   time: ~U[2022-11-10 02:36:27Z],
                   txid: "3f5dcd03d4cda0e161cb18a24228cb3aae009c8db750d0614e9faf2577a194a6"
                 },
                 %{
                   confirmations: _,
                   fee: 200,
                   operations: [
                     %{
                       address: "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
                       direction: :send,
                       type: :self,
                       value: 60000
                     },
                     %{
                       address: "bc1qcpq4nr9z8r02xd7vsg74fzzerr460fljdz2hvp",
                       direction: :receive,
                       type: :external,
                       value: 30000
                     },
                     %{
                       address: "bc1qraquj0s8sz9s57l7rdgqrg5j0u6rr7ek7kp0x4",
                       direction: :receive,
                       type: :self,
                       value: 29800
                     }
                   ],
                   sent_by: :myself,
                   time: ~U[2022-11-10 02:36:27Z],
                   txid: "e445e3dd9828dd61b2b5ae144205d7038d8fb9ab1cb991f5a1bc6b387660ba81"
                 },
                 %{
                   confirmations: _,
                   fee: 200,
                   operations: [
                     %{
                       address: "bc1qraquj0s8sz9s57l7rdgqrg5j0u6rr7ek7kp0x4",
                       direction: :send,
                       type: :self,
                       value: 29800
                     },
                     %{
                       address: "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
                       direction: :receive,
                       type: :self,
                       value: 20000
                     },
                     %{
                       address: "bc1qcshhqc3qnztrl9yqd0dyphswqkgwkatcnetctm",
                       direction: :receive,
                       type: :self,
                       value: 9600
                     }
                   ],
                   sent_by: :myself,
                   time: ~U[2022-11-11 01:31:11Z],
                   txid: "97b6e12a670ea61cb5e397af1f7049f6b8b39318506bb9e4e2c5c3f2e0b1b035"
                 },
                 %{
                   confirmations: _,
                   fee: 200,
                   operations: [
                     %{
                       address: "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
                       direction: :send,
                       type: :self,
                       value: 20000
                     },
                     %{
                       address: "bc1q0qqlc7fms63asxqptz8lkneufvglwpqf7fp2qs",
                       direction: :receive,
                       type: :self,
                       value: 8800
                     },
                     %{
                       address: "bc1qdlcyqx907w7nyryfut5vn4p8fe4su7qfwhxnvjqsyw0vc77czw9q6d8zkl",
                       direction: :receive,
                       type: :external,
                       value: 6000
                     },
                     %{
                       address: "bc1qzwll7ttd6q4csdl32mr0nlsw5umrmau4es49qe",
                       direction: :receive,
                       type: :external,
                       value: 5000
                     }
                   ],
                   sent_by: :myself,
                   time: ~U[2022-11-12 22:58:55Z],
                   txid: "f318dd60cc36fb1238e39abf697b471881ed811f2f66b0bdeed15e29d3032c76"
                 }
               ]
             },
             %{address: "bc1q6czq8kzp9ma6mnchnwx2rrl6rc89g5j946s2xu", entries: []},
             %{address: "bc1q7zyyhjx3664d00km5evdnnn04fjdqun94wac4x", entries: []},
             %{address: "bc1q60qe9q602wt04dfmgjvnefhygudhgyp9pla8ta", entries: []},
             %{address: "bc1qhptec2x9j7kpmkscxglscxnlj8hpdk4c3rfqpj", entries: []},
             %{address: "bc1qu7s0jpnt0nuqac0wdvhj3kkrhgdqg574uzzuz4", entries: []},
             %{address: "bc1qpuxm23rf5wd996xl7lv2s9dywm4vqdp954j2wx", entries: []},
             %{address: "bc1qznuz9ly0m6484z9wl7uwk55yj6fp9pvqc2pjh0", entries: []},
             %{address: "bc1qr3a7euk4sd7wv44r7mn5qhachhya49rgezrner", entries: []},
             %{address: "bc1q8kw86hwvft8nqgcdzmamahscra7lwq265msgwh", entries: []},
             %{address: "bc1q9r53pqlgv2n7z8e6u0lp54z7qv7arxl6pmx7h7", entries: []},
             %{address: "bc1qpd9tlpy3tl0ll32wsrw4x6s904f64xtqged6mt", entries: []},
             %{address: "bc1qvlhqlqjar367snz6kj3z3nzrlqzaxx5j66zz4m", entries: []},
             %{address: "bc1qh2tzf8fwnxwudjaumlmhh3x6pprput04q33efx", entries: []},
             %{address: "bc1qurkq6jl37fscag76l0l74w8lnevh6jh9rqgqfe", entries: []},
             %{address: "bc1q9nemx3q3fzpgvfynktr3va4ecy2yyk87a2z90q", entries: []},
             %{address: "bc1q80k5w4ld7wm3zqhnk2t4jwet668wyqqxw97p4s", entries: []},
             %{address: "bc1qqtmtwrc632z4npq5ql0279c46lmac967jpwvsw", entries: []},
             %{address: "bc1qxcf0hezju3d4tp0ckemjkv4v70ezl8y55tpzfu", entries: []},
             %{address: "bc1qn69ay5255c89epnkayh9tj67rcdysxq3x3rjx5", entries: []},
             %{address: "bc1qtxs2txu428cm8lpdjfxr6r7usrcju8aj5n8smz", entries: []},
             %{address: "bc1qvndlrkgr8n65ufxnvc5hc0e2hg7hug2ffm9mc4", entries: []},
             %{address: "bc1qvlhta3vmzvwy6qure52qxlfqpkmk5mdzjrxerc", entries: []},
             %{address: "bc1qejqpy9845etw0svn5dehgq46qjxvxpeyhg380u", entries: []},
             %{address: "bc1qhuj2ecknl8gqm2x5qp3jk7de0ul6z4uj63ytex", entries: []},
             %{address: "bc1q679yyerem6jywns0g6u804d27dyne0kphp5gkd", entries: []},
             %{address: "bc1qaqtfj8cd2v7v6p272nqjpzpkfy7hp5hjcp6tdd", entries: []},
             %{address: "bc1qg3975n7mx6p56asnvncs4cq29x6xuvwny6ghmv", entries: []},
             %{address: "bc1q0qgw0jgeqg0ujc6jn5r5wmqv5fpkchud6vd3f7", entries: []},
             %{address: "bc1qfg6hctzy8e6a36edcq73ws8p75fclfrp6udj90", entries: []},
             %{address: "bc1q6al9ctk6vxwxqq8tymqx0y743hustssapea4z7", entries: []},
             %{address: "bc1q2zy60zlqtte42dnls555vsv4ugs74gh6s8f9ty", entries: []},
             %{address: "bc1qvsjaf6geey00nxuaper7jl5qvafvfur522k7fh", entries: []},
             %{address: "bc1qzuxvydqtn7apfq9an9d4cvreat382q4dutnknv", entries: []},
             %{address: "bc1qe8xj4uqrwk5r5jx6cpkqkwgfeaxhwvhpfv4xzr", entries: []},
             %{address: "bc1qa86xvaw82zff5munn3uschug8s62m8lznmsdjl", entries: []},
             %{address: "bc1qpkwy2r0uh034dddlnquuf930hfe88m3pfvehf3", entries: []},
             %{address: "bc1q39nms9wkqcyf7nde8jwatadnzzntzr99a6rmcz", entries: []},
             %{address: "bc1qhnwfycw4jsqmxcvr0qw7hagcnutgfrp8gk6pfm", entries: []},
             %{address: "bc1qlmdp9k0dqjhkrte0xmhw6rtu8l7mzg578anxzw", entries: []}
           ] =
             BitcoinAccounting.ElectrumReport.for(
               "zpub6nMFHiw6cmjijjGr7V9dpdUWoKkcvbL7pzRxdgZ1q1R2SfBb5Az6F2PWmHZoENT3spQfHTrdAeQRQ6bdyu3mCqtN1jYkEyYQvvvgAhaBaHG",
               20
             )

    assert confirmations > 829
  end
end
