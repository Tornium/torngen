defmodule Torngen.Generator.FS do
  @moduledoc false

  @outdir Application.compile_env(:torngen, :out_dir, nil)

  @spec write_files(map()) :: nil
  def write_files(%{} = files) do
    files
    |> Map.keys()
    |> Enum.map(&Path.dirname/1)
    |> do_create_dirs()

    files
    |> Map.to_list()
    |> do_write_files()
  end

  defp do_create_dirs([directory | remaining_directories]) do
    outdir_valid!()

    @outdir
    |> Path.join(directory)
    |> Path.expand()
    |> File.mkdir_p!()

    do_create_dirs(remaining_directories)
  end

  defp do_create_dirs([]), do: nil

  defp do_write_files([{file_path, file_data} | remaining_files]) do
    outdir_valid!()

    @outdir
    |> Path.join(file_path)
    |> Path.expand()
    |> File.write!(file_data)

    do_write_files(remaining_files)
  end

  defp do_write_files([]), do: nil

  @spec outdir_valid!() :: boolean()
  defp outdir_valid!() do
    if is_nil(@outdir) do
      raise("Missing output directory in config")
    end

    true
  end
end
