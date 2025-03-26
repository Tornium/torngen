defmodule Torngen.Spec.Parameter.Schema do
  defstruct [:style, :explode, :schema, allow_reserved: false]

  @type t :: %__MODULE__{
          style: String.t(),
          explode: boolean(),
          allow_reserved: boolean(),
          schema: nil
        }
end
