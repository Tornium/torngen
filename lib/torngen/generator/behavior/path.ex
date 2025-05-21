defmodule Torngen.Generator.Behavior.Path do
  @moduledoc false

  @callback generate_all(spec :: Torngen.Spec.t()) :: [tuple()]

  @callback generate(path_spec :: Torngen.Spec.Path.t(), spec :: Torngen.Spec.t()) :: tuple()
end
