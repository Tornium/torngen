defmodule Torngen.Generator.Python do
  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Python 3.x"

  @impl true
  def generate(%Torngen.Spec{} = _spec) do
  end
end
