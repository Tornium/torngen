defmodule Torngen.Spec.Schema.ObjectPair do
  defstruct [:key, :value, :required, :deprecated]

  @type t :: %__MODULE__{
          key: String.t(),
          value: Torngen.Spec.Schema.schema_types() | Torngen.Spec.Reference.t(),
          required: boolean(),
          deprecated: boolean()
        }

  @spec parse_many(spec :: Torngen.Spec.t(), properties :: [], required_keys :: [String.t()]) :: [
          t()
        ]
  def parse_many(%Torngen.Spec{} = spec, properties, required_keys)
      when is_list(properties) and is_list(required_keys) do
    do_parse_many(spec, properties, required_keys, [])
  end

  def do_parse_many(
        %Torngen.Spec{} = spec,
        [{key, property} = _property | remaining_properties] = _properties,
        required_keys,
        accumulator
      )
      when is_list(required_keys) do
    do_parse_many(spec, remaining_properties, required_keys, [
      parse(spec, key, required_keys, property) | accumulator
    ])
  end

  def do_parse_many(%Torngen.Spec{} = _spec, [], required_keys, accumulator)
      when is_list(required_keys) do
    accumulator
  end

  defp parse(%Torngen.Spec{} = spec, key, required_keys, %{} = property)
       when is_binary(key) do
    %Torngen.Spec.Schema.ObjectPair{
      key: key,
      value: Torngen.Spec.Schema.parse(spec, property),
      required: Enum.member?(required_keys, key),
      deprecated: Map.get(property, "deprecated", false)
    }
  end
end
