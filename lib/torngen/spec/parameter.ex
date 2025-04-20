defmodule Torngen.Spec.Parameter do
  @moduledoc ~S"""
  Represents all parameters for OpenAPI requests.

  ## External Resources
  - [Swagger Specification](https://swagger.io/specification#parameter-object)
  """

  @type parameter_locations :: :path | :query | :header | :cookie

  defstruct [
    :name,
    :in,
    :body,
    reference: nil,
    description: nil,
    required: false,
    deprecated: false
  ]

  @typedoc ~S"""
  Represents all parameters.

  ## Fields
    * `name` - Name of the parameter. Correspond to the key used for the parameter (except for `:header` parameters).
    * `in` - Location of the parameter.
    * `body` - N/A
    * `reference` - Reference identifier to a parameter's schema.
    * `description` - Description of the parameter (either text or markdown).
    * `required` - Mandatory parameter flag.
    * `deprecated` - Deprecated parameter flag.
  """
  @type t :: %__MODULE__{
          reference: String.t() | nil,
          name: String.t(),
          in: parameter_locations(),
          description: String.t() | nil,
          required: boolean(),
          deprecated: boolean(),
          body: Torngen.Spec.Parameter.Schema.t() | Torngen.Spec.Parameter.Content.t() | nil
        }

  @spec parse_many(spec :: Torngen.Spec.t(), parameters :: map() | [term()]) :: Torngen.Spec.t()
  def parse_many(%Torngen.Spec{} = spec, parameters) when is_map(parameters) do
    parse_many(spec, Map.to_list(parameters))
  end

  def parse_many(%Torngen.Spec{} = spec, parameters) when is_list(parameters) do
    do_parse_many(spec, parameters, [])
  end

  @spec do_parse_many(
          spec :: Torngen.Spec.t(),
          parameters :: [term()],
          parsed_parameters :: [t()]
        ) :: Torngen.Spec.t()
  defp do_parse_many(
         %Torngen.Spec{} = spec,
         [{parameter_ref, parameter} | remaining_parameters] = _parameters,
         parsed_parameters
       ) do
    parameter = Map.put(parameter, "reference", parameter_ref)
    do_parse_many(spec, remaining_parameters, [parse(parameter, spec) | parsed_parameters])
  end

  defp do_parse_many(
         %Torngen.Spec{} = spec,
         [parameter | remaining_parameters] = _parameters,
         parsed_parameters
       ) do
    parameter = Map.put(parameter, "reference", nil)
    do_parse_many(spec, remaining_parameters, [parse(parameter, spec) | parsed_parameters])
  end

  defp do_parse_many(%Torngen.Spec{} = spec, [] = _parameters, parsed_parameters) do
    %Torngen.Spec{spec | parameters: parsed_parameters}
  end

  @spec parse(parameter :: map(), spec :: Torngen.Spec.t()) :: t()
  def parse(%{"$ref" => path}, %Torngen.Spec{} = _spec) when is_binary(path) do
    %Torngen.Spec.Reference{ref: path}
  end

  def parse(
        %{
          "schema" => _schema
        } = parameter,
        %Torngen.Spec{} = spec
      ) do
    parsed_schema = nil
    # parsed_schema = Torngen.Spec.Parameter.Schema.parse(schema)
    # TODO: Add parameter schema parser

    parameter
    |> Map.delete("schema")
    |> parse(spec)
    |> Map.put(:body, parsed_schema)
  end

  def parse(
        %{
          "content" => _content
        } = parameter,
        %Torngen.Spec{} = spec
      ) do
    parsed_content = nil
    # parsed_content = Torngen.Spec.Parameter.Content.parse(content)
    # TODO: Add parameter content parser

    parameter
    |> Map.delete("content")
    |> parse(spec)
    |> Map.put(:body, parsed_content)
  end

  def parse(
        %{
          "reference" => reference,
          "name" => name,
          "in" => "path"
        } = parameter,
        %Torngen.Spec{} = _spec
      ) do
    # Parameter is required when `:in` equals `:path`

    %Torngen.Spec.Parameter{
      reference: reference,
      name: name,
      in: :path,
      description: Map.get(parameter, "description", "N/A"),
      required: true,
      deprecated: Map.get(parameter, "deprecated", false)
    }
  end

  def parse(
        %{
          "reference" => reference,
          "name" => name,
          "in" => parameter_in
        } = parameter,
        %Torngen.Spec{} = _spec
      ) do
    %Torngen.Spec.Parameter{
      reference: reference,
      name: name,
      in: String.to_atom(parameter_in),
      description: Map.get(parameter, "description", "N/A"),
      required: Map.get(parameter, "required", false),
      deprecated: Map.get(parameter, "deprecated", false)
    }
  end
end
