defmodule Torngen.Generator.Markdown.Parameter do
  @moduledoc false

  @behaviour Torngen.Generator.Behavior.Parameter

  @impl true
  def generate_all(%Torngen.Spec{parameters: parameters} = spec) when is_list(parameters) do
    do_generate_all(parameters, spec, [])
  end

  @impl true
  def generate(parameter_or_reference, %Torngen.Spec{} = spec) do
    generate(parameter_or_reference, spec, [])
  end

  @impl true
  def generate(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Markdown.priv_path()}/parameter.md.eex"
      |> EEx.eval_file(parameter: parameter, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"parameter/#{parameter.reference || parameter.name}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec, opts) do
    parameter = Torngen.Spec.Reference.retrieve(spec, ref)

    generate(parameter, spec, opts)
  end

  defp do_generate_all(
         [%Torngen.Spec.Parameter{} = parameter | remaining_parameters],
         %Torngen.Spec{} = spec,
         accumulator
       ) do
    do_generate_all(remaining_parameters, spec, [generate(parameter, spec) | accumulator])
  end

  defp do_generate_all([], %Torngen.Spec{} = _spec, accumulator) do
    accumulator
  end
end
