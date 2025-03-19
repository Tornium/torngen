defmodule Torngen.Spec.Schema.Array do
  defstruct [:type, reference: nil]

  @type t :: %__MODULE__{
          type: Torngen.Spec.Schema.schema_types(),
          reference: Torngen.Spec.Reference.t() | nil
        }

  def parse(%Torngen.Spec{} = spec, %{"type" => "array", "items" => array_schema} = schema) do
    %Torngen.Spec.Schema.Array{
      type: Torngen.Spec.Schema.parse(spec, array_schema),
      reference: Map.get(schema, "reference", nil)
    }
  end
end
