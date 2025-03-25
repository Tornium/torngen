defmodule Torngen.Generator.Elixir.Parameter do
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
  def generate(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = spec, opts)
      when is_list(opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.base_path()}/parameter.ex.eex"
      |> EEx.eval_file(parameter: parameter, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"parameter/#{parameter.reference || parameter.name}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec, opts) do
    parameter = Torngen.Spec.Reference.retrieve(spec, ref)

    generate(parameter, spec, opts)
  end

  def generate_docs(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = _spec) do
    "#{Torngen.Generator.Elixir.base_path()}/parameter_doc.eex"
    |> EEx.eval_file(parameter: parameter)
    |> Torngen.Generator.cleanup()
  end

  def generate_docs(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec) do
    generate_docs(Torngen.Spec.Reference.retrieve(spec, ref), spec)
  end

  def generate_handler(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = _spec) do
    "#{Torngen.Generator.Elixir.base_path()}/parameter_handler.ex.eex"
    |> EEx.eval_file(parameter: parameter)
    |> Torngen.Generator.cleanup()
  end

  def generate_handler(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec) do
    generate_handler(Torngen.Spec.Reference.retrieve(spec, ref), spec)
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
