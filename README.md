# Torngen
An [Elixir](https://elixir-lang.org) library to generate language-agnostic clients for the [Torn API](https://www.torn.com/swagger/index.html).

> [!IMPORTANT]
> As a special exception, you may create a larger work that contains part or all of the `torngen` templates and distribute that work under terms of your choice, so long as that work isn't itself a template for code generation. Alternatively, if you modify or redistribute the template itself, you may (at your option) remove this special exception, which will cause the template and the resulting Generator output files to be licensed under the GNU General Public License v3 without this special exception.

## Supported Languages
- Elixir
- Python 3.x (in-dev)
- Markdown (partial)

## Installation
Once [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `torngen` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:torngen, "~> 0.1.0"}
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
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/torngen>.

