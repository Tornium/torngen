defmodule Torngen.Spec.Schema.Object do
  @moduledoc ~S"""
  Schema of an object.
  """

  defstruct [:pairs]

  @type t :: %__MODULE__{
          pairs: [Torngen.Spec.Schema.ObjectPair.t()]
        }

  def parse(%Torngen.Spec{} = spec, %{"type" => "object", "properties" => properties} = _schema) do
    %Torngen.Spec.Schema.Object{
      pairs: Torngen.Spec.Schema.ObjectPair.parse_many(spec, Map.to_list(properties))
    }
  end
end
