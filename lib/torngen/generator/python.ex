defmodule Torngen.Generator.Python do
  @moduledoc false

  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Python 3.x"

  @impl true
  def priv_path(), do: Path.join(:code.priv_dir(:torngen), "python")

  @impl true
  def generate(%Torngen.Spec{} = spec) do
    [
      generate_statics(spec),
      spec
      |> Torngen.Generator.Python.Path.generate_all()
      |> Map.new(),
      Torngen.Generator.Python.Path.generate_init(spec),
      spec
      |> Torngen.Generator.Python.Schema.generate_all()
      |> Map.new()
    ]
    |> Enum.reduce(&Map.merge/2)
    |> Torngen.Generator.FS.write_files()
  end

  defp generate_statics(%Torngen.Spec{} = spec) do
    "#{Torngen.Generator.Python.priv_path()}/static/"
    |> File.ls!()
    |> do_generate_static(spec, [])
    |> Map.new()
  end

  defp do_generate_static([file | remaining_files], %Torngen.Spec{} = spec, accumulator) do
    path = "#{Torngen.Generator.Python.priv_path()}/static/#{file}"

    file_name =
      file
      |> String.split(".")
      |> Enum.drop(-1)
      |> Enum.join(".")

    file_contents =
      path
      |> EEx.eval_file(spec: spec)

    do_generate_static(remaining_files, spec, [{file_name, file_contents} | accumulator])
  end

  defp do_generate_static([], _spec, accumulator) do
    accumulator
  end

  @spec to_string(value :: any()) :: String.t()
  def to_string(value)

  def to_string(true), do: "True"
  def to_string(false), do: "False"

  @doc """
  Replace reserved keywords with "\#{keyword}_"

  Source: https://docs.python.org/3/reference/lexical_analysis.html#keywords
  """
  @spec handle_reserved(value :: String.t()) :: String.t()
  def handle_reserved(value) do
    case value do
      _
      when value in [
             "False",
             "await",
             "else",
             "import",
             "pass",
             "None",
             "break",
             "except",
             "in",
             "raise",
             "True",
             "class",
             "finally",
             "is",
             "return",
             "and",
             "continue",
             "for",
             "lambda",
             "try",
             "as",
             "def",
             "from",
             "nonlocal",
             "while",
             "assert",
             "del",
             "global",
             "not",
             "with",
             "async",
             "elif",
             "if",
             "or",
             "yield"
           ] ->
        "#{value}_"

      _ ->
        value
    end
  end
end
