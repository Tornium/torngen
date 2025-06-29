defmodule Torngen.Generator.Python.Path do
  @moduledoc false

  @behaviour Torngen.Generator.Behavior.Path

  @impl true
  def generate_all(%Torngen.Spec{paths: paths} = spec) when is_list(paths) do
    paths
    |> Enum.group_by(fn %Torngen.Spec.Path{path: path} -> base_path(path) end)
    |> Enum.reject(fn {resource, _paths} -> resource == "" end)
    |> Enum.map(fn {resource, paths} when is_list(paths) -> generate(resource, paths, spec) end)
  end

  @impl true
  def generate(%Torngen.Spec.Path{} = path, %Torngen.Spec{} = spec), do: raise("Not implemented")

  def generate(
        resource,
        [%Torngen.Spec.Path{} = _first_path | _remaining_paths] = paths,
        %Torngen.Spec{} = spec
      )
      when is_binary(resource) do
    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/path_resource.py.eex"
      |> EEx.eval_file(
        resource: resource |> Macro.camelize(),
        paths: paths,
        spec: spec
      )
      |> Torngen.Generator.cleanup()

    {"path/#{resource}.py", rendered_string}
  end

  defp update_path_name("{" <> path_parameter) when is_binary(path_parameter) do
    path_parameter
    |> String.split_at(-1)
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  defp update_path_name(path_section), do: path_section

  defp base_path(path_str) when is_binary(path_str) do
    path_str
    |> String.split("/")
    |> Enum.slice(0..-2//1)
    |> Enum.map_join("_", &update_path_name/1)
  end
end
