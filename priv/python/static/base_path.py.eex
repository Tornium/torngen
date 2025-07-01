import typing

from base_schema import BaseSchema
from parameter import Parameter


class Path:
    def __init__(
        self,
        path_uri: str,
        response_schema: BaseSchema,
        **parameters: typing.Dict[str, Parameter]
    ):
        self.selection: str = path_uri.split("/")[-1]
        self.response_schema: BaseSchema = response_schema
        self.parameters = parameters
