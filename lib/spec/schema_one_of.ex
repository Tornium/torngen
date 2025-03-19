defmodule Torngen.Spec.Schema.OneOf do
  defstruct [:types, reference: nil]

  @type t :: %__MODULE__{
          types: [Torngen.Spec.Schema.schema_types()],
          reference: Torngen.Spec.Reference.t() | nil
        }

  def parse(
        %Torngen.Spec{} = spec,
        %{"oneOf" => schemas} = schema
      )
      when is_list(schemas) do
    %Torngen.Spec.Schema.AllOf{
      types: do_parse(spec, schemas, []),
      reference: Map.get(schema, "reference", nil)
    }
  end

  defp do_parse(
         %Torngen.Spec{} = spec,
         [schema | remaining_schemas] = _schemas,
         accumulator
       ) do
    do_parse(spec, remaining_schemas, [Torngen.Spec.Schema.parse(spec, schema) | accumulator])
  end

  defp do_parse(%Torngen.Spec{} = _spec, [], accumulator) do
    accumulator
  end
end
