defmodule BitcoinAccounting.MixProject do
  use Mix.Project

  @version "0.1.30"

  def project do
    [
      app: :bitcoin_accounting,
      version: @version,
      description: "From Bitcoin blockchain's data to human understandable format",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      preferred_cli_env: [
        test_all: :test
      ]
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
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:hammox, "~> 0.7", only: [:test]},
      {:electrum_client, "~> 0.1.29"}
    ]
  end

  defp aliases() do
    [
      compile: ["compile --warning-as-errors"],
      test: ["test --no-start"],
      test_all: ["test --no-start --include integration"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
