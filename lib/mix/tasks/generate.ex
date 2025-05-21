defmodule Mix.Tasks.Torngen.Generate do
  @moduledoc """
  Uses Torngen to generate the paths and response modules for the [Torn API](https://api.torn.com) for the specified language.

  ## Configuration
  Torngen will automatically pull in information from your application configuration. This can configuration can include the path to the OpenAPI specification file and the language to be generated; for example:

  ```elixir
  config :torngen,
    file: "openapi.json"
  ```
  """
  # TODO: Add more to the moduledoc for the mix task

  use Mix.Task

  @doc false
  @impl true
  def run(_argv) do
    file = Application.get_env(:torngen, :file) || raise "OpenAPI spec file required"

    file
    |> File.read!()
    |> Torngen.Spec.decode()
    |> Torngen.Spec.parse()
    |> Torngen.Generator.generate()
  end
end
