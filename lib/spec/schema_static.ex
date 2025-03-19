defmodule Torngen.Spec.Schema.Static do
  @moduledoc ~S"""
  Schema of static types such as integers.
  """

  defstruct [:type]

  @type types :: :enum
  @type child_types :: :string | :number | :integer | :boolean
  @type t :: %__MODULE__{
          type: child_types()
        }

  def parse(%Torngen.Spec{} = _spec, %{"type" => type} = _schema) do
    %Torngen.Spec.Schema.Static{
      type: String.to_atom(type)
    }
  end
end
