defmodule Torngen.Generator.Python.Schema do
  @moduledoc false

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
    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_any.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec)
      |> Torngen.Generator.cleanup()

    {"schema/any.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Static{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_static.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Array{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_array.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Object{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_object.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.ObjectPair{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_object_pair.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{nil}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Enum{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_enum.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.OneOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_one_of.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AllOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_all_of.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AnyOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)

    rendered_string =
      "#{Torngen.Generator.Python.priv_path()}/schema_any_of.py.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference |> Macro.underscore()}.py", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec, opts) do
    parameter = Torngen.Spec.Reference.retrieve(spec, ref)
    {_, rendered_string} = generate(parameter, spec, opts)

    "#/components/schemas/" <> ref_id = ref
    {"schema/#{ref_id}.py", rendered_string}
  end

  # TODO: Handle when types are duplicated (e.g. `str | str` in`RacingSelectionName`)
  @spec resolve_type(
          schema_spec :: Torngen.Spec.Schema.schema_types(),
          spec :: Torngen.Spec.t(),
          allow_reference :: boolean()
        ) ::
          String.t()
  def resolve_type(schema, spec, allow_reference \\ true)

  def resolve_type(:any = _schema, %Torngen.Spec{} = _spec, _) do
    "typing.Any"
  end

  def resolve_type(%Torngen.Spec.Schema.Static{type: type} = _schema, %Torngen.Spec{} = _spec, _) do
    case type do
      :string -> "str"
      :number -> "int | float"
      :integer -> "int"
      :boolean -> "bool"
      :null -> "None"
    end
  end

  def resolve_type(%Torngen.Spec.Schema.Array{type: type} = _schema, %Torngen.Spec{} = spec, _) do
    "typing.List[#{resolve_type(type, spec)}]"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Object{reference: reference} = _schema,
        %Torngen.Spec{} = _spec,
        true
      )
      when not is_nil(reference) do
    reference
  end

  def resolve_type(
        %Torngen.Spec.Schema.Object{pairs: pairs} = _schema,
        %Torngen.Spec{} = _spec,
        _
      )
      when pairs == [] do
    "typing.Dict[str, typing.Any]"
  end

  def resolve_type(%Torngen.Spec.Schema.Object{pairs: pairs} = _schema, %Torngen.Spec{} = spec, _) do
    map_inner =
      Enum.map_join(pairs, ",\n", fn %Torngen.Spec.Schema.ObjectPair{} = pair ->
        resolve_type(pair, spec)
      end)

    # An anonymous typed dict is required when the Torn API spec does not have an identifier for the 
    # dict.
    # TODO: In the future, this should likely be a separate object and a separate generated file
    "typing.TypedDict(\"\", {#{map_inner}})"
  end

  def resolve_type(
        %Torngen.Spec.Schema.ObjectPair{key: key, value: value} = _schema,
        %Torngen.Spec{} = spec,
        _
      )
      when is_binary(key) do
    # The key of an object pair should always be a string due to the JSON Schema spec (assumed)
    # TODO: Update parser to add required flag to k-v pairs and update the type resolver

    "\"#{key}\": #{resolve_type(value, spec)}"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Enum{reference: reference} = _schema,
        %Torngen.Spec{} = _spec,
        true
      )
      when not is_nil(reference) do
    reference
  end

  def resolve_type(
        %Torngen.Spec.Schema.Enum{type: :string, values: values} = _schema,
        %Torngen.Spec{} = _spec,
        _
      ) do
    "typing.Literal[#{Enum.map_join(values, ", ", fn value -> "\"" <> value <> "\"" end)}]"
  end

  def resolve_type(
        %Torngen.Spec.Schema.Enum{values: values} = _schema,
        %Torngen.Spec{} = _spec,
        _
      ) do
    "typing.Literal[#{Enum.join(values, ", ")}]"
  end

  def resolve_type(
        %Torngen.Spec.Schema.OneOf{reference: reference},
        %Torngen.Spec{} = _spec,
        true
      )
      when not is_nil(reference) do
    reference
  end

  def resolve_type(%Torngen.Spec.Schema.OneOf{types: types}, %Torngen.Spec{} = spec, _)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(%Torngen.Spec.Schema.OneOf{types: types}, %Torngen.Spec{} = spec, _) do
    Enum.map_join(types, " | ", fn type -> resolve_type(type, spec) end)
  end

  def resolve_type(
        %Torngen.Spec.Schema.AllOf{reference: reference},
        %Torngen.Spec{} = _spec,
        true
      )
      when not is_nil(reference) do
    reference
  end

  def resolve_type(%Torngen.Spec.Schema.AllOf{types: types} = _schema, %Torngen.Spec{} = spec, _)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(
        %Torngen.Spec.Schema.AllOf{types: types} = _schema,
        %Torngen.Spec{} = spec,
        allow_reference
      ) do
    # NOTE: This makes the assumption that all schemas containing allOf are for objects
    %Torngen.Spec.Schema.Object{
      pairs:
        Enum.flat_map(types, fn type ->
          Torngen.Spec.Reference.maybe_resolve(spec, type) |> Map.fetch!(:pairs)
        end),
      nullable: false,
      reference: nil
    }
    |> resolve_type(spec, allow_reference)
  end

  def resolve_type(
        %Torngen.Spec.Schema.AnyOf{reference: reference},
        %Torngen.Spec{} = _spec,
        true
      )
      when not is_nil(reference) do
    reference
  end

  def resolve_type(%Torngen.Spec.Schema.AnyOf{types: types}, %Torngen.Spec{} = spec, _)
      when Kernel.length(types) == 1 do
    types
    |> Enum.at(0)
    |> resolve_type(spec)
  end

  def resolve_type(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = _spec, true) do
    "#/components/schemas/" <> ref_id = ref
    ref_id
  end

  def resolve_type(
        %Torngen.Spec.Reference{ref: "#/components/schemas/" <> _ref_id = ref} = _reference,
        %Torngen.Spec{} = spec,
        false
      ) do
    Torngen.Spec.Reference.retrieve(spec, ref)
    |> resolve_type(spec)
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

  @doc """
  Filter a schema for the required imports in Python.

  It is assumed that the necessary child imports will be done by these imports.
  """
  @spec filter_imports(schema :: Torngen.Spec.Schema.schema_types(), spec :: Torngen.Spec.t()) ::
          [String.t()]
  def filter_imports(%Torngen.Spec.Reference{ref: ref}, _spec) do
    "#/components/schemas/" <> ref_id = ref
    [ref_id]
  end

  def filter_imports(%Torngen.Spec.Schema.AllOf{types: types} = _schema, %Torngen.Spec{} = spec) do
    # Given AllOf expands the types into types' code generation, the imports of the 
    # child types will also be needed
    types
    |> Enum.map(fn type ->
      Torngen.Spec.Reference.maybe_resolve(spec, type)
      |> filter_imports(spec)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def filter_imports(%{type: type} = _schema, %Torngen.Spec{} = spec) do
    # e.g. array and enum
    filter_imports(type, spec)
  end

  def filter_imports(%{types: types} = _schema, %Torngen.Spec{} = spec) do
    # e.g. OneOf
    types
    |> Enum.map(fn type -> filter_imports(type, spec) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def filter_imports(schema, _spec) when is_map(schema) and is_map_key(schema, "reference") do
    # e.g. non-inline object
    [schema.reference]
  end

  def filter_imports(%Torngen.Spec.Schema.Object{pairs: pairs} = _schema, %Torngen.Spec{} = spec) do
    pairs
    |> Enum.map(fn %Torngen.Spec.Schema.ObjectPair{value: value} = _pair ->
      filter_imports(value, spec)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def filter_imports(_schema, _spec), do: []
end
