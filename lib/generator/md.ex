defmodule Torngen.Generator.Markdown do
  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Markdown"

  @impl true
  def base_path(), do: "lib/generator/md"

  @impl true
  def generate(%Torngen.Spec{} = spec) do
    [
      spec
      |> Torngen.Generator.Markdown.Parameter.generate_all()
      |> Map.new(),
      spec
      |> Torngen.Generator.Markdown.Path.generate_all()
      |> Map.new(),
      spec
      |> Torngen.Generator.Markdown.Schema.generate_all()
      |> Map.new()
    ]
    |> Enum.reduce(&Map.merge/2)
    |> Torngen.Generator.FS.write_files()
  end
end
