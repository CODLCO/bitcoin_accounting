defmodule BitcoinAccounting.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :bitcoin_accounting,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BitcoinAccounting.Application, []}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "BitcoinAccounting",
      source_ref: @version,
      source_url: "https://github.com/roosoft/bitcoin_accounting"
    ]
  end

  def package do
    [
      maintainers: ["Marc Lacoursière"],
      licenses: ["UNLICENCE"],
      links: %{"GitHub" => "https://github.com/roosoft/bitcoin_accounting"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:electrum_client, "~> 0.1.4"}
    ]
  end
end
