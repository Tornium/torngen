defmodule Torngen.Generator.Markdown.Path do
  @behaviour Torngen.Generator.Behavior.Path

  require EEx

  @impl true
  def generate_all(%Torngen.Spec{paths: paths} = spec) when is_list(paths) do
    do_generate_all(paths, spec, [])

    nil
  end

  @impl true
  def generate(%Torngen.Spec.Path{} = path, %Torngen.Spec{} = spec) do
    # TODO: switch to `EEx.compile_file`
    EEx.eval_file("#{Torngen.Generator.Markdown.base_path}/path.md.eex", path: path, spec: spec)
  end

  defp do_generate_all([%Torngen.Spec.Path{} = path | remaining_paths], %Torngen.Spec{} = spec, accumulator) do
    do_generate_all(remaining_paths, spec, [generate(path, spec) | accumulator])
  end

  defp do_generate_all([], %Torngen.Spec{} = _spec, accumulator) do
    accumulator
  end
end
