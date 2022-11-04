defmodule BitcoinAccounting.AddressManager.JournalEntriesTest do
  use ExUnit.Case, async: false
  import Hammox
  alias BitcoinAccounting.AddressManager.JournalEntries

  setup :verify_on_exit!

  describe "from_transaction_request/2" do
    test "calculate debits" do
      expect(ElectrumClientMock, :get_transaction, fn expected_address ->
        assert expected_address == transaction_input_fixture().transaction.id

        transaction_input_fixture()
      end)

      assert JournalEntries.from_transaction_request(transaction_fixture(), "12CL4K2eVqj7hQTix7dM7CVHCkpP17Pry3") == %{
               confirmations: 396_000,
               credits: [],
               debits: [17936],
               time: ~U[2015-07-17 17:10:05Z],
               txid: "536160170732da68c9744a22ef2a9196f44ac4877f9cf2fae9002823fbcfafbf"
             }
    end
  end

  defp transaction_fixture() do
    %{
      block_hash: "000000000000000005d682a39582e30549cfde3aff956d8f6e6cd3f181aa581a",
      confirmations: 396_000,
      time: ~U[2015-07-17 17:10:05Z],
      transaction: %BitcoinLib.Transaction{
        version: 1,
        id: "536160170732da68c9744a22ef2a9196f44ac4877f9cf2fae9002823fbcfafbf",
        inputs: [
          %BitcoinLib.Transaction.Input{
            txid: "8615c3852c43074c1b335650ffe08428b0760bc30416f7a7ad8c90a01f77f4a5",
            vout: 1,
            script_sig: [
              %BitcoinLib.Script.Opcodes.Data{
                value:
                  <<0x304502203CC93A6AF1210DC8199D2EE9B823B5A8C01C62F61A4AE86E4F5E9F6ABA05163A022100CDB7811A4716625A5A0377E9BD013C11FC5BCF32A96ED12DE4C477FA4FD5DF9701::576>>
              },
              %BitcoinLib.Script.Opcodes.Data{
                value: <<0x02756DE182C5DD4B717EA87E693006DA62DBB3CDDAA4A5CAD2ED1F5BBAB755F0F5::264>>
              }
            ],
            sequence: 4_294_967_295
          }
        ],
        outputs: [
          %BitcoinLib.Transaction.Output{
            value: 15936,
            script_pub_key: [
              %BitcoinLib.Script.Opcodes.Stack.Dup{},
              %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
              %BitcoinLib.Script.Opcodes.Data{value: <<0x2881E5A14F533C7A73377601B12EC7A0059D7FC8::160>>},
              %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
              %BitcoinLib.Script.Opcodes.Crypto.CheckSig{
                script: <<0x76A9142881E5A14F533C7A73377601B12EC7A0059D7FC888AC::200>>
              }
            ]
          }
        ],
        locktime: 0,
        witness: []
      },
      vsize: 192
    }
  end

  defp transaction_input_fixture() do
    %{
      block_hash: "00000000000000000a310e2c1148f95e6c32c0d9438b9a30f24837ede6c3c136",
      confirmations: 396_010,
      time: ~U[2015-07-17 16:22:20Z],
      transaction: %BitcoinLib.Transaction{
        version: 1,
        id: "8615c3852c43074c1b335650ffe08428b0760bc30416f7a7ad8c90a01f77f4a5",
        inputs: [
          %BitcoinLib.Transaction.Input{
            txid: "7e6ddcf959ee85e23823649fed5242f47e700f7917e82a402774dea2796360a6",
            vout: 1,
            script_sig: [
              %BitcoinLib.Script.Opcodes.Data{
                value:
                  <<0x304402202181227DDAB08A931E4C46D20FE6015056E9EF7BF7D038558EC3C4F49A100BEF022011BFF29901C46AF7FA3229189BD74FC6F8C4E9C876B740F537C262CFBF3598B401::568>>
              },
              %BitcoinLib.Script.Opcodes.Data{
                value: <<0x03C3630E476B5878A0C212671B2984C4D1D87730A2316A916E2E19E75881A701DD::264>>
              }
            ],
            sequence: 4_294_967_295
          }
        ],
        outputs: [
          %BitcoinLib.Transaction.Output{
            value: 37533,
            script_pub_key: [
              %BitcoinLib.Script.Opcodes.Stack.Dup{},
              %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
              %BitcoinLib.Script.Opcodes.Data{value: <<0x06D6FF37AD15C672F57AF90081C51CC142EAF204::160>>},
              %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
              %BitcoinLib.Script.Opcodes.Crypto.CheckSig{
                script: <<0x76A91406D6FF37AD15C672F57AF90081C51CC142EAF20488AC::200>>
              }
            ]
          },
          %BitcoinLib.Transaction.Output{
            value: 17936,
            script_pub_key: [
              %BitcoinLib.Script.Opcodes.Stack.Dup{},
              %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
              %BitcoinLib.Script.Opcodes.Data{value: <<0x0D1C9C02A7BE9BA8B8842804FEB961481CE6561B::160>>},
              %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
              %BitcoinLib.Script.Opcodes.Crypto.CheckSig{
                script: <<0x76A9140D1C9C02A7BE9BA8B8842804FEB961481CE6561B88AC::200>>
              }
            ]
          }
        ],
        locktime: 0,
        witness: []
      },
      vsize: 225
    }
  end
end
