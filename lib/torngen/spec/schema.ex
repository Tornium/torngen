defmodule Torngen.Spec.Schema do
  @moduledoc """
  ## External Resources
  - [Swagger Specification](https://swagger.io/specification/#response-object)
  - [Swagger Docs](https://swagger.io/docs/specification/v3_0/data-models/data-types/)
  """

  @type schema_types ::
          Torngen.Spec.Schema.ObjectPair.t()
          | Torngen.Spec.Schema.Object.t()
          | Torngen.Spec.Schema.Enum.t()
          | Torngen.Spec.Schema.Static.t()
          | Torngen.Spec.Schema.Array.t()
          | Torngen.Spec.Schema.OneOf.t()
          | Torngen.Spec.Schema.AllOf.t()
          | Torngen.Spec.Schema.AnyOf.t()
          | Torngen.Spec.Reference.t()
          | :any

  @spec parse_many(spec :: Torngen.Spec.t(), schemas :: map()) :: Torngen.Spec.t()
  def parse_many(%Torngen.Spec{} = spec, %{} = schemas) when is_map(schemas) do
    do_parse(spec, Map.to_list(schemas), [])
  end

  @spec do_parse(
          spec :: Torngen.Spec.t(),
          schema :: [map()],
          schema_accumulator :: [schema_types()]
        ) :: Torngen.Spec.t()
  defp do_parse(
         %Torngen.Spec{} = spec,
         [{schema_ref, %{} = schema} | remaining_schemas],
         schema_accumulator
       ) do
    schema = Map.put(schema, "reference", schema_ref)
    do_parse(spec, remaining_schemas, [parse(spec, schema) | schema_accumulator])
  end

  defp do_parse(%Torngen.Spec{} = spec, [], schema_accumulator) do
    %Torngen.Spec{spec | schemas: schema_accumulator}
  end

  def parse(
        %Torngen.Spec{} = _spec,
        %{"$ref" => reference} = _schema
      ) do
    %Torngen.Spec.Reference{
      ref: reference
    }
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"oneOf" => _properties} = schema
      ) do
    Torngen.Spec.Schema.OneOf.parse(spec, schema)
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"anyOf" => _properties} = schema
      ) do
    Torngen.Spec.Schema.AnyOf.parse(spec, schema)
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"allOf" => _properties} = schema
      ) do
    Torngen.Spec.Schema.AllOf.parse(spec, schema)
  end

  # NOTE: The `not` keyword is not implemented
  # https://swagger.io/docs/specification/v3_0/data-models/oneof-anyof-allof-not/#not

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => _type, "enum" => _enum_data} = schema
      ) do
    Torngen.Spec.Schema.Enum.parse(spec, schema)
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => "object"} = schema
      ) do
    Torngen.Spec.Schema.Object.parse(spec, schema)
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => "array"} = schema
      ) do
    Torngen.Spec.Schema.Array.parse(spec, schema)
  end

  def parse(
        %Torngen.Spec{} = spec,
        %{"type" => _type} = schema
      ) do
    Torngen.Spec.Schema.Static.parse(spec, schema)
  end

  def parse(%Torngen.Spec{} = _spec, %{} = _schema) do
    :any
  end

  @spec references(spec :: Torngen.Spec.t(), schema :: Torngen.Spec.Schema.schema_types()) :: [String.t()]
  def references(%Torngen.Spec{} = spec, %Torngen.Spec.Reference{ref: ref}) do
    references(spec, Torngen.Spec.Reference.retrieve(spec, ref))
  end

  def references(%Torngen.Spec{} = _spec, %{reference: reference}) when not is_nil(reference) do
    # To avoid unnescessarily expanding anyOf, allOf, and oneOf when there is a reference already,
    # just return the reference so that all parsing/handling can be done by the specific logic for
    # schema type
    [reference]
  end

  def references(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.AllOf{types: types}) do
    Enum.flat_map(types, fn schema -> references(spec, schema) end)
  end

  def references(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.AnyOf{types: types}) do
    Enum.flat_map(types, fn schema -> references(spec, schema) end)
  end

  def references(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.OneOf{types: types}) do
    Enum.flat_map(types, fn schema -> references(spec, schema) end)
  end

  def references(%Torngen.Spec{} = _spec, schema) do
    [schema.reference]
  end
end
