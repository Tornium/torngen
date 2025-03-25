defmodule Torngen.Entrypoint do
  @spec main(argv :: OptionParser.argv()) :: no_return()
  def main(argv) do
    {opts, _positional_opts, _errors} =
      OptionParser.parse(argv,
        switches: [
          version: :boolean,
          help: :boolean,
          license: :boolean,
          file: :string,
          outdir: :string,
          generator: :string
        ],
        aliases: [v: :version, h: :help]
      )

    case Torngen.Options.validate(opts) do
      {:ok, validated_options} ->
        validated_options
        |> Torngen.Options.parse()
        |> IO.inspect(label: "Parsed opts")
        |> entrypoint()

      {:error, message} ->
        IO.puts("Error: #{inspect(message.message)}")
        System.halt(1)
    end
  end

  @spec entrypoint(otps :: Torngen.Options.t()) :: no_return()
  def entrypoint(%Torngen.Options{help: true} = _opts) do
    IO.puts("Usage: torngen [options...]")
    IO.puts(" --file                    Set the input Open API JSON file")
    IO.puts(" --outdir                  Set the output directory (default: \".out/\")")
    IO.puts(" --generator               Set the code generator (default: \"markdown\")")
    IO.puts(" --version, -v             Show version")
    IO.puts(" --help, -h                Show help message")
    IO.puts(" --license                 Show license")

    System.halt(0)
  end

  def entrypoint(%Torngen.Options{version: true} = _opts) do
    "torngen #{Application.spec(:torngen)[:vsn]}\nElixir #{System.version()} #{:erlang.system_info(:system_version)}"
    |> String.trim_trailing()
    |> IO.puts()

    System.halt(0)
  end

  def entrypoint(%Torngen.Options{license: true} = _opts) do
    IO.puts("torngen Copyright (C) 2025 tiksan")
    IO.puts("This program comes with ABSOLUTELY NO WARRANTY.")
    IO.puts("This is free software, and you are welcome to redistribute it")
    IO.puts("under certain conditions.")

    System.halt(0)
  end

  def entrypoint(%Torngen.Options{file: file_path} = _opts)
      when is_nil(file_path) or Kernel.length(file_path) == 0 do
    "https://www.torn.com/swagger/openapi.json"
    |> Req.get!()
    |> Map.get(:body)
    |> Torngen.Spec.parse()
    |> Torngen.Generator.Markdown.generate()
  end

  def entrypoint(%Torngen.Options{file: file_path} = opts) do
    case File.read(file_path) do
      {:ok, data} when is_binary(data) ->
        data
        |> Torngen.Spec.decode()
        |> Torngen.Spec.parse()
        |> Torngen.Generator.generate(opts)

      {:error, reason} ->
        IO.puts(:stderr, "#{file_path}: #{:file.format_error(reason)}")

        System.halt(1)
    end
  end
end
