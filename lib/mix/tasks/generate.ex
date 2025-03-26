defmodule Mix.Tasks.Torngen.Generate do
  @moduledoc "Foo"
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
