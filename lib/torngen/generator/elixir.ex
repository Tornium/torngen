defmodule Torngen.Generator.Elixir do
  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Elixir"

  @impl true
  def priv_path(), do: Path.join(:code.priv_dir(:torngen), "elixir")

  @impl true
  def generate(%Torngen.Spec{} = spec) do
    [
      generate_statics(),
      spec
      |> Torngen.Generator.Elixir.Parameter.generate_all()
      |> Map.new(),
      spec
      |> Torngen.Generator.Elixir.Path.generate_all()
      |> Map.new()
      # spec
      # |> Torngen.Generator.Elixir.Schema.generate_all()
      # |> Map.new()
    ]
    |> Enum.reduce(&Map.merge/2)
    |> Torngen.Generator.FS.write_files()
  end

  defp generate_statics() do
    "#{Torngen.Generator.Elixir.priv_path()}/static/"
    |> File.ls!()
    |> do_generate_static([])
    |> Map.new()
  end

  defp do_generate_static([file | remaining_files], accumulator) do
    path = "#{Torngen.Generator.Elixir.priv_path()}/static/#{file}"

    file_name =
      file
      |> String.split(".")
      |> Enum.at(0)

    do_generate_static(remaining_files, [{"#{file_name}.ex", File.read!(path)} | accumulator])
  end

  defp do_generate_static([], accumulator) do
    accumulator
  end
end
