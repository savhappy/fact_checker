defmodule FactChecker.MixProject do
  use Mix.Project

  def project do
    [
      app: :fact_checker,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ets, "~> 0.9"},
      {:jason, ">= 1.0.0"}
    ]
  end
end
