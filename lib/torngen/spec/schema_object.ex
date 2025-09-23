defmodule Torngen.Spec.Schema.Object do
  @moduledoc """
  Schema of an object.
  """

  defstruct [:pairs, :nullable, reference: nil]

  @type t :: %__MODULE__{
          pairs: [Torngen.Spec.Schema.ObjectPair.t()],
          nullable: boolean(),
          reference: Torngen.Spec.Reference.t() | nil
        }

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => "object", "required" => required_keys, "properties" => properties} = schema
      ) do
    %Torngen.Spec.Schema.Object{
      pairs: Torngen.Spec.Schema.ObjectPair.parse_many(spec, Map.to_list(properties), required_keys),
      nullable: Map.get(schema, "nullable", false),
      reference: Map.get(schema, "reference", nil)
    }
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => "object", "properties" => properties} = schema
      ) do
    %Torngen.Spec.Schema.Object{
      pairs: Torngen.Spec.Schema.ObjectPair.parse_many(spec, Map.to_list(properties), []),
      nullable: Map.get(schema, "nullable", false),
      reference: Map.get(schema, "reference", nil)
    }
  end

  def parse(%Torngen.Spec{} = _spec, %{"type" => "object"} = schema) do
    %Torngen.Spec.Schema.Object{
      pairs: [],
      nullable: Map.get(schema, "nullable", false),
      reference: Map.get(schema, "reference", nil)
    }
  end
end
