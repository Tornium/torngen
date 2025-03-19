defmodule Torngen.Spec.Schema.Enum do
  @moduledoc ~S"""
  Schema of enum of a single type.
  """

  defstruct [:type, :values]

  @type types :: :string | :number | :integer | :boolean
  @type t :: %__MODULE__{
          type: types(),
          values: [String.t() | number() | integer() | boolean()]
        }

  def parse(%Torngen.Spec{} = _spec, %{"type" => type, "enum" => enum_values} = _schema) do
    %Torngen.Spec.Schema.Enum{
      type: String.to_atom(type),
      values: enum_values
    }
  end
end
