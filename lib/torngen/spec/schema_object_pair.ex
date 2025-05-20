defmodule Torngen.Spec.Schema.ObjectPair do
  defstruct [:key, :value, :deprecated]

  @type t :: %__MODULE__{
          key: String.t(),
          value: Torngen.Spec.Schema.schema_types() | Torngen.Spec.Reference.t(),
          deprecated: boolean()
        }

  def parse_many(%Torngen.Spec{} = spec, properties) when is_list(properties) do
    do_parse_many(spec, properties, [])
  end

  def do_parse_many(
        %Torngen.Spec{} = spec,
        [{key, property} = _property | remaining_properties] = _properties,
        accumulator
      ) do
    do_parse_many(spec, remaining_properties, [parse(spec, key, property) | accumulator])
  end

  def do_parse_many(%Torngen.Spec{} = _spec, [], accumulator) do
    accumulator
  end

  defp parse(%Torngen.Spec{} = spec, key, %{} = property)
       when is_binary(key) do
    %Torngen.Spec.Schema.ObjectPair{
      key: key,
      value: Torngen.Spec.Schema.parse(spec, property),
      deprecated: Map.get(property, "deprecated", false)
    }
  end
end
