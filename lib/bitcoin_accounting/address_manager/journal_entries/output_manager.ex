defmodule BitcoinAccounting.AddressManager.JournalEntries.OutputManager do
  require Logger

  alias BitcoinLib.{Address, Script}

  def identify_script_type(output, network) do
    Script.identify(output.script_pub_key)
    |> add_address(network)
  end

  defp add_address({:p2pk, pub_key}, _network) do
    {:p2pk, pub_key, pub_key}
  end

  defp add_address({:p2pkh, pub_key_hash}, network) do
    address =
      pub_key_hash
      |> Address.from_public_key_hash(network)

    {:p2pk, pub_key_hash, address}
  end

  defp add_address({:p2wpkh, pub_key_hash}, network) do
    address =
      pub_key_hash
      |> Address.Bech32.from_public_key_hash(network)

    {:p2wpkh, pub_key_hash, address}
  end

  defp add_address({:p2sh, script_hash}, network) do
    address =
      script_hash
      |> Address.P2SH.from_script_hash(network)

    {:p2sh, script_hash, address}
  end

  defp add_address({:bech32, script_hash}, network) do
    address =
      <<0x0020::16, script_hash::bitstring-160>>
      |> Address.Bech32.from_script_hash(network)

    {:p2sh, script_hash, address}
  end
end
