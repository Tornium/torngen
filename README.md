# Torngen
An [Elixir](https://elixir-lang.org) library to generate language-agnostic clients for the [Torn API](https://www.torn.com/swagger/index.html).

## Supported Languages
`torngen` currently supports the following languages (and the following generated clients):
- Elixir: [`torngen_elixir_client`](https://github.com/Tornium/torngen_elixir_client)
- Python 3.x: [`torngen_python_client`](https://github.com/Tornium/torngen_python_client)
- Markdown (partial): None

## Installation
Once [available in Hex](https://hex.pm/docs/publish), the library can be installed
by adding `torngen` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:torngen, "~> 0.1"}
  ]
end
```

For latest changes, you can also install the library directly from [GitHub](https://github.com/Tornium/torngen):

```elixir
def deps do
  [
    {:torngen, github: "Tornium/torngen"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and can be found at <https://hexdocs.pm/torngen>.

## Configuration
`torngen` can be configured to generate certain output with the following options:
- `:generator`: Language of generator to use (`:elixir`, `:md`, or module generating code implementing `Torngen.Generator.Behavior`)
- `:out_dir`: Directory to output the generated code
- `:file`: Path to the OpenAPI specification file

For example:
```elixir
config :torngen,
  file: "openapi.json",
  out_dir: ".out/",
  generator: :elixir
```

## License
Copyright 2024-2025 tiksan

This project is licensed under GPLv3; see [LICENSE.md](LICENSE.md) for more details.

> **IMPORTANT**:
> As a special exception, you may create a larger work that contains part or all of the `torngen` templates and distribute that work under terms of your choice, so long as that work isn't itself a template for code generation. Alternatively, if you modify or redistribute the template itself, you may (at your option) remove this special exception, which will cause the template and the resulting Generator output files to be licensed under the GNU General Public License v3 without this special exception.
