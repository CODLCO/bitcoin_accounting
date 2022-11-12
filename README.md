# BitcoinAccounting

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bitcoin_accounting` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bitcoin_accounting, "~> 0.1.13"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bitcoin_accounting>.

## Testing

Please set `LB_ELECTRUM_CLIENT_IP` and `LB_ELECTRUM_CLIENT_PORT` environment variables with your Electrum server credentials for integration tests to pass.
