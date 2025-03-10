defmodule Torngen.MixProject do
  use Mix.Project

  def project do
    [
      app: :torngen,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
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
      {:nimble_options, "~> 1.0"}
    ]
  end

  defp escript do
    [
      main_module: Torngen.Entrypoint
    ]
  end
end
