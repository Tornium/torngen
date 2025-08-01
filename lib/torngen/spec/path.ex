defmodule Torngen.Spec.Path do
  defstruct [:path, :tags, :summary, :description, :parameters, :response]

  @type t :: %__MODULE__{
          path: String.t(),
          tags: [String.t()],
          summary: String.t() | nil,
          description: String.t(),
          parameters: [Torngen.Spec.Parameter.t()],
          response: Torngen.Spec.Reference.t() | Torngen.Spec.Schema.schema_types()
        }

  @spec parse_many(spec :: Torngen.Spec.t(), paths :: map()) :: Torngen.Spec.t()
  def parse_many(%Torngen.Spec{} = spec, %{} = paths) when is_map(paths) do
    parse(spec, Map.to_list(paths), [])
  end

  def parse(
        %Torngen.Spec{} = spec,
        [
          {
            "/" <> path,
            %{
              "get" =>
                %{
                  "tags" => tags,
                  "responses" => %{
                    "200" => %{
                      "content" => %{"application/json" => %{"schema" => response_schema}}
                    }
                  }
                } = data
            }
          }
          | paths_remaining
        ],
        path_accumulator
      ) do
    parameters =
      data
      |> Map.get("parameters", [])
      |> Enum.map(fn parameter ->
        parameter
        |> Map.put("reference", nil)
        |> Torngen.Spec.Parameter.parse(spec)
      end)

    parse(spec, paths_remaining, [
      %Torngen.Spec.Path{
        path: path,
        tags: tags,
        summary:
          data
          |> Map.get("summary", "N/A")
          |> String.replace(["<br>", "\n"], " ")
          |> String.split()
          |> Enum.join(" ")
          |> String.trim(),
        description:
          data
          |> Map.get("description", "N/A")
          |> String.replace(["<br>", "\n"], " ")
          |> String.split()
          |> Enum.join(" ")
          |> String.trim(),
        parameters: parameters,
        response: Torngen.Spec.Schema.parse(spec, response_schema)
      }
      | path_accumulator
    ])
  end

  def parse(%Torngen.Spec{} = spec, [], path_accumulator) do
    %Torngen.Spec{spec | paths: path_accumulator}
  end

  def url(%Torngen.Spec.Path{path: path}, %Torngen.Spec{api_servers: [server_url | _]} = _spec) do
    server_url
    |> URI.new!()
    |> URI.append_path("/" <> path)
  end
end
