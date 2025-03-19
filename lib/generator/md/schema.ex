defmodule Torngen.Generator.Markdown.Schema do
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
      "#{Torngen.Generator.Markdown.base_path()}/schema_any.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec)
      |> Torngen.Generator.cleanup()

    {"schema/any.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Static{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_static.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Array{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_array.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Object{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_object.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.ObjectPair{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_object_pair.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{nil}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.Enum{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_enum.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.OneOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_one_of.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AllOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_all_of.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Schema.AnyOf{} = schema, %Torngen.Spec{} = spec, opts) do
    external = Keyword.get(opts, :external, false)
    rendered_string =
      "#{Torngen.Generator.Markdown.base_path()}/schema_any_of.md.eex"
      |> EEx.eval_file(schema: schema, spec: spec, external: external)
      |> Torngen.Generator.cleanup()

    {"schema/#{schema.reference}.md", rendered_string}
  end

  @impl true
  def generate(%Torngen.Spec.Reference{ref: ref} = _reference, %Torngen.Spec{} = spec, opts) do
    parameter = Torngen.Spec.Reference.retrieve(spec, ref)
    {_, rendered_string} = generate(parameter, spec, opts)

    "#/components/schemas/" <> ref_id = ref
    {"schema/#{ref_id}.md", rendered_string}
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
