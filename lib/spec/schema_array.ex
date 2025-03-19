defmodule Torngen.Spec.Schema.Array do
  defstruct [:type]

  @type t :: %__MODULE__{
          type: Torngen.Spec.Schema.schema_types()
        }

  def parse(%Torngen.Spec{} = spec, %{"type" => "array", "items" => array_schema} = _schema) do
    %Torngen.Spec.Schema.Array{
      type: Torngen.Spec.Schema.parse(spec, array_schema)
    }
  end
end
