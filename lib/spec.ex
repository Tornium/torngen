defmodule Torngen.Spec do
  defstruct [:open_api_version, :api_name, :api_description, :api_version, :parameters, :paths]

  @type t :: %__MODULE__{
          open_api_version: String.t(),
          api_name: String.t(),
          api_description: String.t(),
          api_version: String.t(),
          parameters: [Torngen.Spec.Parameter.t()],
          paths: [Torngen.Spec.Path.t()]
        }

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

      {:error, reason} ->
        IO.puts(:stderr, "Unable to parse JSON (invalid error): #{inspect(reason)}")
        System.halt(1)
    end
  end

  def parse(
        %{
          "openapi" => open_api_version,
          "paths" => paths,
          "components" => %{"parameters" => parameters}
        } = _data
      ) do
    %Torngen.Spec{
      open_api_version: open_api_version
    }
    |> Torngen.Spec.Parameter.parse_many(parameters)
    |> Torngen.Spec.Path.parse_many(paths)
    |> IO.inspect()

    # TODO: Put API info
  end
end
