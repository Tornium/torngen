defmodule Torngen.Generator.Behavior.Path do
  @callback generate_all(spec :: Torngen.Spec.t()) :: nil

  @callback generate(path_spec :: Torngen.Spec.Path.t(), spec :: Torngen.Spec.t()) :: [tuple()]
end
