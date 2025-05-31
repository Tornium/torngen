defmodule Torngen.Spec do
  @moduledoc """
  An intermediate representation of the Torn API OpenAPI specification.
  """

  defstruct [
    :open_api_version,
    :api_name,
    :api_description,
    :api_version,
    api_servers: [],
    parameters: [],
    paths: [],
    schemas: []
  ]

  @typedoc """
  The internal representation of the OpenAPI specification.

  This IR will be utilized when performing the code generation while remaining language-agnostic.

  ## Fields
  - `open_api_version`: The OpenAPI specification version
  - `api_servers`: List of base URIs for the API
  - `api_name`: Name of the API
  - `api_description`: Description for the API
  - `api_version`: Semver API versioning
  - `parameters`: Parsed API parameters
  - `paths`: Parsed API paths
  - `schemas`: Parsed API response schemas
  """
  @type t :: %__MODULE__{
          open_api_version: String.t() | nil,
          api_servers: [String.t()],
          api_name: String.t() | nil,
          api_description: String.t() | nil,
          api_version: String.t() | nil,
          parameters: [Torngen.Spec.Parameter.t()],
          paths: [Torngen.Spec.Path.t()],
          schemas: [Torngen.Spec.Schema.schema_types()]
        }

  @doc false
  @spec decode(data :: String.t()) :: map()
  def decode(data) when is_binary(data) do
    case JSON.decode(data) do
      {:ok, decoded_data} ->
        decoded_data

      {:error, {:unexpected_end, _offset}} ->
        IO.puts(:stderr, "Unable to parse JSON: unexpected end")
        System.halt(1)

      {:error, {:invalid_byte, _offset, _byte}} ->
        IO.puts(:stderr, "Unable to parse JSON: unexpected byte or invalid UTF-8 byte")
        System.halt(1)

      {:error, {:unexpected_sequence, _, _}} ->
        IO.puts(:stderr, "Unable to parse JSON: contains invalid UTF-8 escape")
        System.halt(1)
    end
  end

  @doc """
  Parse the decoded OpenAPI specification into this intermediate representation.
  """
  @spec parse(data :: map()) :: t()
  def parse(
        %{
          "openapi" => open_api_version,
          "servers" => servers,
          "info" => info,
          "paths" => paths,
          "components" => %{"parameters" => parameters, "schemas" => schemas}
        } = _data
      )
      when is_map(info) do

    %Torngen.Spec{
      open_api_version: open_api_version
    }
    |> parse_api_data(info)
    |> parse_servers(servers)
    |> Torngen.Spec.Parameter.parse_many(parameters)
    |> Torngen.Spec.Path.parse_many(paths)
    |> Torngen.Spec.Schema.parse_many(schemas)
  end

  @spec parse_api_data(spec :: t(), data :: map()) :: t()
  defp parse_api_data(
         %Torngen.Spec{} = spec,
         %{"title" => title, "version" => version, "description" => description} = _data
       ) do
    %Torngen.Spec{spec | api_name: title, api_version: version, api_description: description}
  end

  defp parse_servers(
         %Torngen.Spec{} = spec,
         servers
       )
       when is_list(servers) do
    %Torngen.Spec{spec | api_servers: Enum.map(servers, fn %{"url" => url} -> url end)}
  end
end
