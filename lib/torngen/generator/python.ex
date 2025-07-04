defmodule Torngen.Generator.Python do
  @moduledoc false

  @behaviour Torngen.Generator.Behavior

  @impl true
  def language(), do: "Python 3.x"

  @impl true
  def priv_path(), do: "lib/generator/python"

  @impl true
  def generate(%Torngen.Spec{} = _spec) do
  end
end
