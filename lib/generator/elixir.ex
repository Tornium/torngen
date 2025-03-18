defmodule Torngen.Generator.Elixir do
  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Elixir"

  @impl true
  def generate(%Torngen.Spec{} = _spec) do
  end
end
