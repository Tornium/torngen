defmodule Torngen.Spec.Parameter.Schema do
  @moduledoc """
  The specification of parameters using schemas to handle their type.
  """

  defstruct [:style, :explode, :schema, allow_reserved: false]

  @type t :: %__MODULE__{
          style: String.t() | nil,
          explode: boolean() | nil,
          allow_reserved: boolean(),
          schema: Torngen.Spec.Schema.schema_types()
        }

  @spec parse(spec :: Torngen.Spec.t(), parameter :: %{String.t() => term()}) :: t()
  def parse(%Torngen.Spec{} = spec, %{"schema" => schema} = parameter) do
    %__MODULE__{
      style: Map.get(parameter, "style"),
      explode: Map.get(parameter, "explode"),
      allow_reserved: Map.get(parameter, "allow_reserved", false),
      schema: Torngen.Spec.Schema.parse(spec, schema)
    }
  end
end
