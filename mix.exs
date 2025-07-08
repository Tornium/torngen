defmodule Torngen.MixProject do
  use Mix.Project

  @version "0.2.0-dev"

  def project do
    [
      name: "Torngen",
      description: "Language-agnostic code generator for the Torn APIv2",
      app: :torngen,
      version: @version,
      elixir: "~> 1.18",
      deps: deps(),
      docs: docs(),
      package: package(),
      source_url: "https://github.com/Tornium/torngen",
      homepage_url: "https://github.com/Tornium/torngen"
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:plug, "~> 1.18"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE.md"]
    ]
  end

  defp package do
    [
      name: "torngen",
      description: "Language-agnostic code generator for the Torn APIv2",
      files: ["lib", "priv", "mix.exs", "README.md", "LICENSE.md", "CHANGELOG.md"],
      maintainers: ["tiksan"],
      licenses: ["GPL-3.0-only"],
      links: %{"GitHub" => "https://github.com/Tornium/torngen"}
    ]
  end
end
