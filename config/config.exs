import Config

if config_env() == :test do
  config :bitcoin_accounting,
    electrum_client: ElectrumClientMock
else
  config :bitcoin_accounting,
    electrum_client: ElectrumClient
end
