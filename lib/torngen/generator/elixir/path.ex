defmodule Torngen.Generator.Elixir.Path do
  @behaviour Torngen.Generator.Behavior.Path

  @impl true
  def generate_all(%Torngen.Spec{paths: paths} = spec) when is_list(paths) do
    do_generate_all(paths, spec, [])
  end

  @impl true
  def generate(%Torngen.Spec.Path{} = path, %Torngen.Spec{} = spec) do
    path_module_name =
      path.path
      |> String.split("/")
      |> Enum.map(&update_path_name/1)
      |> Enum.join(".")

    response_module_names = Torngen.Spec.Schema.references(spec, path.response)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/path.ex.eex"
      |> EEx.eval_file(path_module_name: path_module_name, response_module_names: response_module_names, path: path, spec: spec)
      |> Torngen.Generator.cleanup()

    {"path/#{path.path}.ex", rendered_string}
  end

  defp do_generate_all(
         [%Torngen.Spec.Path{} = path | remaining_paths],
         %Torngen.Spec{} = spec,
         accumulator
       ) do
    do_generate_all(remaining_paths, spec, [generate(path, spec) | accumulator])
  end

  defp do_generate_all([], %Torngen.Spec{} = _spec, accumulator) do
    accumulator
  end

  defp update_path_name("{" <> path_parameter) when is_binary(path_parameter) do
    path_parameter
    |> String.split_at(-1)
    |> Tuple.to_list()
    |> Enum.at(0)
    |> Macro.camelize()
  end

  defp update_path_name(path_section) do
    path_section
    |> Macro.camelize()
  end
end
