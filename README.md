# BitcoinAccounting

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bitcoin_accounting` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bitcoin_accounting, "~> 0.1.23"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bitcoin_accounting>.

## Testing

## Integration tests

To test lib against real Electrum server please set `LB_ELECTRUM_CLIENT_IP`, `LB_ELECTRUM_CLIENT_PORT` and run `mix test_all`
