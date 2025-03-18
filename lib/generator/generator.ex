defmodule Torngen.Generator do
  def generators do
    [
      Torngen.Generator.Markdown,
      Torngen.Generator.Python,
      Torngen.Generator.Elixir,
    ]
  end

  @doc false
  def cleanup(rendered_string) when is_binary(rendered_string) do
    rendered_string
    # |> String.replace(~r/\n{2,}/, "\n")
    |> String.trim()
  end
end
