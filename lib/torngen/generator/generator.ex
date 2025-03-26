defmodule Torngen.Generator do
  require Logger

  def generators do
    [
      Torngen.Generator.Markdown,
      Torngen.Generator.Python,
      Torngen.Generator.Elixir
    ]
  end

  def generate(%Torngen.Spec{} = spec) do
    generator = Application.get_env(:torngen, :generator) || raise "Generator required in config"

    generator_module = case generator do
      :md -> Torngen.Generator.Markdown
      :elixir -> Torngen.Generator.Elixir
      _ -> raise "Unknown generator \"#{generator}\" provided in config"
    end

    generator_module.generate(spec)
  end

  @doc false
  def cleanup(rendered_string) when is_binary(rendered_string) do
    rendered_string
    # |> String.replace(~r/\n{2,}/, "\n")
    |> String.trim()
  end
end
