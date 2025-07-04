defmodule Mix.Tasks.Torngen.Generate do
  @moduledoc """
  Uses Torngen to generate the paths and response modules for the [Torn API](https://api.torn.com) for the specified language.
  """

  use Mix.Task

  @doc false
  @impl true
  def run(_argv) do
    file = Application.get_env(:torngen, :file) || raise "OpenAPI spec file required"

    file
    |> File.read!()
    |> Torngen.Spec.decode()
    |> Torngen.Spec.parse()
    |> Torngen.Generator.generate()
  end
end
