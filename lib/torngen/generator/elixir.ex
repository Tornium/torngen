defmodule Torngen.Generator.Elixir do
  @moduledoc false

  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Elixir"

  @impl true
  def priv_path(), do: Path.join(:code.priv_dir(:torngen), "elixir")

  @impl true
  def generate(%Torngen.Spec{} = spec) do
    [
      generate_statics(spec),
      spec
      |> Torngen.Generator.Elixir.Path.generate_all()
      |> Map.new(),
      spec
      |> Torngen.Generator.Elixir.Schema.generate_all()
      |> Map.new()
    ]
    |> Enum.reduce(&Map.merge/2)
    |> Torngen.Generator.FS.write_files()
  end

  defp generate_statics(%Torngen.Spec{} = spec) do
    "#{Torngen.Generator.Elixir.priv_path()}/static/"
    |> File.ls!()
    |> do_generate_static(spec, [])
    |> Map.new()
  end

  defp do_generate_static([file | remaining_files], %Torngen.Spec{} = spec, accumulator) do
    path = "#{Torngen.Generator.Elixir.priv_path()}/static/#{file}"

    file_name =
      file
      |> String.split(".")
      |> Enum.drop(-1)
      |> Enum.join(".")

    file_contents =
      path
      |> EEx.eval_file(spec: spec)

    do_generate_static(remaining_files, spec, [{file_name, file_contents} | accumulator])
  end

  defp do_generate_static([], _spec, accumulator) do
    accumulator
  end

  @doc false
  @spec repr(spec :: Torngen.Spec.t(), element :: Torngen.Spec.Schema.schema_types()) :: any()
  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Reference{ref: ref}) do
    dereferenced = Torngen.Spec.Reference.retrieve(spec, ref)
    repr(spec, dereferenced)
  end

  def repr(%Torngen.Spec{} = _spec, %{reference: ref})
      when not is_nil(ref) do
    # This applies to anything with a reference as the referenced module can have its own parsing and validation
    # excluding Tornium.Spec.Reference as that needs to dereference the reference first
    # e.g. objects and statics containing a reference
    Torngen.Client.Schema
    |> Module.concat(ref)
  end

  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.Object{pairs: pairs}) do
    {
      :object,
      pairs
      |> Enum.map(fn %Torngen.Spec.Schema.ObjectPair{} = pair -> repr(spec, pair) end)
      |> Map.new()
    }
  end

  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.ObjectPair{key: key, value: value})
      when is_binary(key) do
    # Nothing should have an ObjectPair that isn't a child of an Object so this will not include a type
    {key, repr(spec, value)}
  end

  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.Array{type: array_type}) do
    {:array, repr(spec, array_type)}
  end

  def repr(%Torngen.Spec{} = _spec, %Torngen.Spec.Schema.Static{type: type}) do
    {:static, type}
  end

  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.OneOf{types: types}) do
    {:one_of,
     types
     |> Enum.map(fn %{} = type -> repr(spec, type) end)}
  end

  def repr(%Torngen.Spec{} = spec, %Torngen.Spec.Schema.AllOf{types: types}) do
    {:all_of,
     types
     |> Enum.map(fn %{} = type -> repr(spec, type) end)}
  end

  def repr(%Torngen.Spec{} = _spec, %Torngen.Spec.Schema.Enum{type: type, values: values}) do
    {:enum, type, values}
  end

  def repr(%Torngen.Spec{} = _spec, element) do
    element
  end
end
