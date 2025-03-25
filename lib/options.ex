defmodule Torngen.Options do
  @type t :: %__MODULE__{
          version: boolean(),
          help: boolean(),
          license: boolean(),
          file: String.t() | nil,
          outdir: String.t(),
          generator: String.t()
        }

  defstruct [:version, :help, :license, :file, :outdir, :generator]

  @schema [
    help: [
      type: :boolean,
      default: false,
      doc: "Get help"
    ],
    version: [
      type: :boolean,
      default: false,
      doc: "Show version number and quit"
    ],
    license: [
      type: :boolean,
      default: false,
      doc: "Show license"
    ],
    file: [
      type: :any,
      default: nil,
      doc: "Path to JSON spec file"
    ],
    outdir: [
      type: :string,
      default: ".out/",
      doc: "Path to the output directory"
    ],
    generator: [
      type: :string,
      default: "markdown",
      doc: "Generator to be used"
    ]
  ]

  # TODO: Add logger level option

  @spec validate(options :: Keyword) ::
          {:ok, validated_options :: Keyword | map()}
          | {:error, NimbleOptions.ValidationError.t()}
  def validate(options) do
    NimbleOptions.validate(options, @schema)
  end

  def help() do
    NimbleOptions.docs(@schema)
  end

  @spec parse(Keyword) :: t()
  def parse(opts) do
    %Torngen.Options{
      version: Keyword.get(opts, :version, false),
      help: Keyword.get(opts, :help, false),
      license: Keyword.get(opts, :license, false),
      file: Keyword.get(opts, :file, nil),
      outdir: Keyword.get(opts, :outdir, ".out/"),
      generator: Keyword.get(opts, :generator, "markdown")
    }
  end
end
