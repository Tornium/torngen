defmodule Torngen.Spec.Schema.Static do
  @moduledoc """
  Schema for literal of schemas/sub-schemas such as integers.
  """

  defstruct [:type, reference: nil]

  @type child_types :: :string | :number | :integer | :boolean | :null
  @type t :: %__MODULE__{
          type: child_types(),
          reference: Torngen.Spec.Reference.t() | nil
        }

  def parse(%Torngen.Spec{} = _spec, %{"type" => type} = schema) do
    %Torngen.Spec.Schema.Static{
      type: String.to_atom(type),
      reference: Map.get(schema, "reference", nil)
    }
  end
end
