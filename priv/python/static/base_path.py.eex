import typing


class Path:
    def __init__(
        self,
        path_uri: str,
        response_schema,
        **parameters: typing.Dict[
            str, typing.Tuple[typing.Literal["path", "query"], typing.Any]
        ]
    ):
        self.selection: str = path_uri.split("/")[-1]
        self.response_schema = response_schema
        self.parameters = parameters
