defmodule BitcoinAccounting.MixProject do
  use Mix.Project

  def project do
    [
      app: :bitcoin_accounting,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BitcoinAccounting.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:electrum_client, "~> 0.1.3"}
    ]
  end
end
