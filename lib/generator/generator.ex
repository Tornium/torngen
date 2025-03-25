defmodule Torngen.Generator do
  require Logger

  def generators do
    [
      Torngen.Generator.Markdown,
      Torngen.Generator.Python,
      Torngen.Generator.Elixir
    ]
  end

  def generate(%Torngen.Spec{} = spec, %Torngen.Options{generator: "markdown"} = _opts) do
    Torngen.Generator.Markdown.generate(spec)
  end

  def generate(%Torngen.Spec{} = spec, %Torngen.Options{generator: "elixir"} = _opts) do
    Torngen.Generator.Elixir.generate(spec)
  end

  def generate(%Torngen.Spec{} = _spec, %Torngen.Options{generator: generator_name} = _opts) do
    Logger.error("Invalid generator #{generator_name}")

    System.halt(1)
  end

  @doc false
  def cleanup(rendered_string) when is_binary(rendered_string) do
    rendered_string
    # |> String.replace(~r/\n{2,}/, "\n")
    |> String.trim()
  end
end
