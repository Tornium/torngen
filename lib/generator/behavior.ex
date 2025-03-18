defmodule Torngen.Generator.Behavior do
  @moduledoc ~S"""
    Use `@default_impl` to override existing implementations.
  """
  @callback language() :: String.t()

  @callback base_path() :: String.t()

  @callback generate(spec :: Torngen.Spec.t()) :: nil
end
