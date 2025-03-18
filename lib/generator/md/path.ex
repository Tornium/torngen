defmodule Torngen.Generator.Markdown.Path do
  @behaviour Torngen.Generator.Behavior.Path

  @impl true
  def generate_all(%Torngen.Spec{paths: paths} = spec) when is_list(paths) do
    do_generate_all(paths, spec, [])
  end

  @impl true
  def generate(%Torngen.Spec.Path{} = path, %Torngen.Spec{} = spec) do
    rendered_string = 
      "#{Torngen.Generator.Markdown.base_path()}/path.md.eex"
      |> EEx.eval_file(path: path, spec: spec)
      |> Torngen.Generator.cleanup()

    {"path/#{path.path}.md", rendered_string}
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
end
