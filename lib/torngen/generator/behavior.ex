defmodule Torngen.Generator.Behavior do
  @moduledoc false

  @doc "Language for which the generator will generate the code from templates."
  @callback language() :: String.t()

  @doc "Path to the `priv` directory containing the language's .eex code templates."
  @callback priv_path() :: String.t()

  @doc "Generate the files for this language using the provided templates."
  @callback generate(spec :: Torngen.Spec.t()) :: nil
end
