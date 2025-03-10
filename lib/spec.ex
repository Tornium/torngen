defmodule Torngen.Spec do
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

      {:error, {:unexpected_sequence, _}} ->
        IO.puts(:stderr, "Unable to parse JSON: contains invalid UTF-8 escape")
        System.halt(1)

      {:error, reason} ->
        IO.puts(:stderr, "Unable to parse JSON (invalid error): #{inspect(reason)}")
        System.halt(1)
    end
  end

  def parse(%{} = data) do
  end
end
