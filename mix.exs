defmodule Torngen.MixProject do
  use Mix.Project

  @version "0.2.0-dev"

  def project do
    [
      name: "Torngen",
      description: "Language-agnostic code generator for the Torn API",
      app: :torngen,
      version: @version,
      elixir: "~> 1.18",
      deps: deps(),
      docs: docs(),
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
      {:ex_doc, "~> 0.35", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE.md"]
    ]
  end
end
