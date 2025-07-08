import typing

from base_schema import BaseSchema
from parameter import Parameter


class Path:
    """
    Torn APIv2 resource and selection representation.

    This represents a selection for a resource in the Torn APIv2 OpenAPI specification. The representation
    indicates the relationship between a selection, the response schema, and the path/query parameters that
    can be used in an API call against the resource and selection.
    """

    def __init__(
        self,
        path_uri: str,
        response_schema: BaseSchema,
        **parameters: typing.Dict[str, Parameter]
    ):
        self.selection: str = path_uri.split("/")[-1]
        """
        Torn API selection against a resource.
        """

        self.response_schema: BaseSchema = response_schema
        """
        Schema representing the API's response.

        The response schema will be used to parse the Torn API's response for all selections utilized in
        the API call.
        """

        self.parameters: typing.Dict[str, Parameter] = parameters
        """
        Parameters applicable for resource and selection.
        """
