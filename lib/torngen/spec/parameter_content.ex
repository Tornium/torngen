defmodule Torngen.Spec.Parameter.Content do
  @moduledoc ~S"""
  Represents content parameters for OpenAPI requests.

  This struct is intended to extend the base `Torngen.Spec.Parameter` struct when handling parameters for OpenAPI requests.

  ## External Resources
  - [Swagger Specification](https://swagger.io/specification#fixed-fields-for-use-with-content)
  """

  defstruct [:content]

  @typedoc ~S"""
  Represents content parameters.

  ## Fields

    * `content` - A map containing the representations for the parameter. The key is the media type and the value describes it.
  """
  @type t :: %__MODULE__{
          content: map()
        }
end
