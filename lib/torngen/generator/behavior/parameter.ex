defmodule Torngen.Generator.Behavior.Parameter do
  @callback generate_all(spec :: Torngen.Spec.t()) :: [tuple()]

  @callback generate(
              parameter_spec :: Torngen.Spec.Parameter.t() | Torngen.Spec.Reference.t(),
              spec :: Torngen.Spec.t()
            ) :: tuple()

  @callback generate(
              parameter_spec :: Torngen.Spec.Parameter.t() | Torngen.Spec.Reference.t(),
              spec :: Torngen.Spec.t(),
              opts :: Keyword.t()
            ) :: tuple()
end
