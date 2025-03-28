defmodule Torngen.Generator.Behavior.Schema do
  @callback generate_all(spec :: Torngen.Spec.t()) :: [tuple()]

  @callback generate(schema_spec :: Torngen.Spec.Schema.schema_types(), spec :: Torngen.Spec.t()) ::
              tuple()

  @callback generate(
              schema_spec :: Torngen.Spec.Schema.schema_types(),
              spec :: Torngen.Spec.t(),
              opts :: Keyword
            ) :: tuple()
end
