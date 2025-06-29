defmodule Torngen.Spec.Reference do
  defstruct [:ref]

  @type t :: %__MODULE__{
          ref: String.t()
        }

  @spec retrieve(spec :: Torngen.Spec.t(), reference_identifier :: String.t()) ::
          Torngen.Spec.Parameter.t() | Torngen.Spec.Schema.schema_types()
  def retrieve(
        %Torngen.Spec{parameters: parameters} = _spec,
        "#/components/parameters/" <> reference_id
      )
      when is_binary(reference_id) do
    Enum.find(parameters, fn %Torngen.Spec.Parameter{reference: reference} ->
      reference == reference_id
    end)
  end

  def retrieve(
        %Torngen.Spec{schemas: schemas} = _spec,
        "#/components/schemas/" <> reference_id
      )
      when is_binary(reference_id) do
    Enum.find(schemas, fn %{reference: reference} ->
      reference == reference_id
    end)
  end

  def maybe_resolve(%Torngen.Spec{} = spec, %__MODULE__{ref: ref} = _reference) do
    retrieve(spec, ref)
  end

  def maybe_resolve(%Torngen.Spec{} = _spec, value), do: value
end
