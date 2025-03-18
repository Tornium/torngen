defmodule Torngen.Generator.Markdown do
  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Markdown"

  @impl true
  def base_path(), do: "lib/generator/md"

  @impl true
  def generate(%Torngen.Spec{} = spec) do
    spec
    |> Torngen.Generator.Markdown.Path.generate_all()
  end
end
