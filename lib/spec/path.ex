defmodule Torngen.Spec.Path do
  defstruct [:path, :tags, :summary, :description, :parameters, :response]

  @type t :: %{
          path: String.t(),
          tags: [String.t()],
          summary: String.t(),
          description: String.t(),
          # TODO: Add struct for parameters
          parameters: nil,
          # TODO: Add struct for response
          response: nil
        }

  @spec parse_many(paths :: list(map()), path_structs :: list(t())) :: list(t())
  def parse_many(paths, path_structs \\ [])

  def parse_many([path | remaining_paths] = _paths, path_structs) when is_map(path) do
    parse_many(remaining_paths, [parse(path) | path_structs])
  end

  def parse_many([] = _paths, path_structs) do
    path_structs
  end

  def parse(%{
        "tags" => tags,
        "summary" => summary,
        "description" => description,
        "parameters" => paramaters,
        "response" => %{
          "200" => %{"content" => %{"application/json" => %{"schema" => response_schema}}}
        }
      }) do
    %Torngen.Spec.Path{
      path: nil,  # TODO: Grab path
      tags: tags,
      summary: summary,
      description: description,
      parameters: nil,
      response: nil
    }

    # TODO: parse the parameters
    # TODO: Parse the response
  end
end
