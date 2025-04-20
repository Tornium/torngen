defmodule Torngen.Generator.Elixir.Schema do
  @behaviour Torngen.Generator.Behavior.Schema

  @impl true
  def generate_all(%Torngen.Spec{schemas: schemas} = spec) when is_list(schemas) do
    do_generate_all(schemas, spec, [])
  end

  @impl true
  def generate(schema_or_reference, %Torngen.Spec{} = spec) do
    generate(schema_or_reference, spec, [])
  end

  @impl true
  def generate(:any = schema, %Torngen.Spec{} = spec, _opts) do
    IO.inspect(schema)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_any.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec)
      |> Torngen.Generator.cleanup()

    {"schema/any.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Static{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_static.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Array{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_array.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Object{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_object.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.ObjectPair{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_object_pair.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{nil}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Enum{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_enum.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.OneOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_one_of.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AllOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_all_of.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AnyOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Elixir.priv_path()}/schema_any_of.ex.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.ex", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec, opts) do
    parameter = Torngen.Spec.Reference.retrieve(spec, ref)
    {_, rendered_string} = generate(parameter, spec, opts)

    "#/components/schemas/" <> ref_id = ref
    {"schema/#{ref_id}.ex", rendered_string}
  end

  @spec resolve_type(schema_spec :: Torngen.Spec.Schema.schema_types(), spec :: Torngen.Spec.t()) ::
          String.t()
  def resolve_type(:any = _schema, %Torngen.Spec{} = _spec) do
    "term()"
  end

  def resolve_type(%Torngen.Spec.Schema.Static{type: type} = _schema, %Torngen.Spec{} = _spec) do
    case type do
      :string -> "String.t()"
      :number -> "integer() | float()"
      :integer -> "integer()"
      :boolean -> "boolean()"
      :null -> "nil"
    end
  end

  def resolve_type(%Torngen.Spec.Schema.Array{type: type} = _schema, %Torngen.Spec{} = spec) do
    "[#{resolve_type(type, spec)}]"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Object{reference: reference} = _schema,
        %Torngen.Spec{} = _spec
      )
      when not is_nil(reference) do
    "Torngen.Client.Schema.#{reference}.t()"
  end

  def resolve_type(%Torngen.Spec.Schema.Object{pairs: pairs} = _schema, %Torngen.Spec{} = spec) do
    map_inner =
      pairs
      |> Enum.map(fn %Torngen.Spec.Schema.ObjectPair{} = pair -> resolve_type(pair, spec) end)
      |> Enum.join(",\n")

    "%{#{map_inner}}"
  end

  def resolve_type(
        %Torngen.Spec.Schema.ObjectPair{key: key, value: value} = _schema,
        %Torngen.Spec{} = spec
      )
      when is_binary(key) do
    # The key of an object pair should always be a string due to the JSON Schema spec (assumed)
    # TODO: Update parser to add required flag to k-v pairs and update the type resolver

    "#{key} => #{resolve_type(value, spec)}"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Enum{reference: reference} = _schema,
        %Torngen.Spec{} = _spec
      )
      when not is_nil(reference) do
    "Torngen.Client.Schema.#{reference}.values()"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Enum{values: values, type: :string} = _schema,
        %Torngen.Spec{} = _spec
      ) do
    values
    |> Enum.map(fn value -> "\"#{value}\"" end)
    |> Enum.join(", ")
  end

  def resolve_type(%Torngen.Spec.Schema.Enum{values: values} = _schema, %Torngen.Spec{} = _spec) do
    values
    |> Enum.join(", ")
  end

  def resolve_type(%Torngen.Spec.Schema.OneOf{reference: reference}, %Torngen.Spec{} = _spec)
      when not is_nil(reference) do
    "Torngen.Client.Schema.#{reference}.t()"
  end

  def resolve_type(%Torngen.Spec.Schema.OneOf{types: types}, %Torngen.Spec{} = spec)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(%Torngen.Spec.Schema.OneOf{types: types}, %Torngen.Spec{} = spec) do
    types
    |> Enum.map(fn type -> resolve_type(type, spec) end)
    |> Enum.join(" | ")
  end

  def resolve_type(%Torngen.Spec.Schema.AllOf{reference: reference}, %Torngen.Spec{} = _spec)
      when not is_nil(reference) do
    "Torngen.Client.Schema.#{reference}.t()"
  end

  def resolve_type(%Torngen.Spec.Schema.AllOf{types: types}, %Torngen.Spec{} = spec)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(%Torngen.Spec.Schema.AllOf{types: types}, %Torngen.Spec{} = spec) do
    joined_types =
      types
      |> Enum.map(fn type -> resolve_type(type, spec) end)
      |> Enum.join(" | ")

    "[#{joined_types}]"
  end

  def resolve_type(%Torngen.Spec.Schema.AnyOf{reference: reference}, %Torngen.Spec{} = _spec)
      when not is_nil(reference) do
    "Torngen.Client.Schema.#{reference}.t()"
  end

  def resolve_type(%Torngen.Spec.Schema.AnyOf{types: types}, %Torngen.Spec{} = spec)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = _spec) do
    "#/components/schemas/" <> ref_id = ref
    "Torngen.Client.Schema.#{ref_id}.t()"
  end

  defp do_generate_all(
         [schema | remaining_schemas],
         %Torngen.Spec{} = spec,
         accumulator
       ) do
    do_generate_all(remaining_schemas, spec, [generate(schema, spec) | accumulator])
  end

  defp do_generate_all([], %Torngen.Spec{} = _spec, accumulator) do
    accumulator
  end
end
