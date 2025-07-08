defmodule Torngen.Spec.Schema.Enum do
  @moduledoc """
  Schema of enum of a single type.
  """

  defstruct [:type, :values, reference: nil]

  @type types :: :string | :number | :integer | :boolean
  @type t :: %__MODULE__{
          type: types(),
          values: [String.t() | number() | integer() | boolean()],
          reference: Torngen.Spec.Reference.t() | nil
        }

  def parse(%Torngen.Spec{} = _spec, %{"type" => type, "enum" => enum_values} = schema) do
    %Torngen.Spec.Schema.Enum{
      type: String.to_atom(type),
      values: enum_values,
      reference: Map.get(schema, "reference", nil)
    }
  end
end
