defmodule Torngen.Options do
  @type t :: %__MODULE__{
          version: boolean(),
          help: boolean(),
          license: boolean(),
          file: String.t() | nil
        }

  defstruct [:version, :help, :license, :file]

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
      type: :string,
      default: "",
      doc: "Path to JSON spec file"
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
      file: Keyword.get(opts, :file, nil)
    }
  end
end
