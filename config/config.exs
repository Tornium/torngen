import Config

config :torngen,
  file: "openapi.json",
  out_dir: ".out/",
  generator: :elixir

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
