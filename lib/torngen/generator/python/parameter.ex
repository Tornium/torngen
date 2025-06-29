defmodule Torngen.Generator.Python.Parameter do
  @moduledoc false

  # def generate_docs(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = _spec) do
  #   "#{Torngen.Generator.Python.priv_path()}/parameter_doc.py.eex"
  #   |> EEx.eval_file(parameter: parameter)
  #   |> Torngen.Generator.cleanup()
  # end

  # def generate_docs(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec) do
  #   generate_docs(Torngen.Spec.Reference.retrieve(spec, ref), spec)
  # end

  def generate_handler(%Torngen.Spec.Parameter{} = parameter, %Torngen.Spec{} = _spec) do
    "#{Torngen.Generator.Python.priv_path()}/parameter_handler.py.eex"
    |> EEx.eval_file(parameter: parameter)
    |> Torngen.Generator.cleanup()
  end

  def generate_handler(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec) do
    generate_handler(Torngen.Spec.Reference.retrieve(spec, ref), spec)
  end
end
