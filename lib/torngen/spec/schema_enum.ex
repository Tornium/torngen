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

  @spec to_string(enum :: t()) :: String.t()
  def to_string(%__MODULE__{type: type, values: [value]}) do
    if type == :string, do: "\"#{value}\"", else: value
  end

  def to_string(%__MODULE__{type: type, values: values}) when is_list(values) do
    if type == :string do
      Enum.map_join(values, ", ", fn value -> "\"#{value}\"" end)
    else
      Enum.join(values, ", ")
    end
  end
end
