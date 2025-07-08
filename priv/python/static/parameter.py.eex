import typing


class Parameter:
    """
    Representation of a parameter for a resource and selection.
    """

    def __init__(
        self,
        parameter_name: str,
        parameter_in: typing.Literal["query", "path"],
        required: bool = False,
        deprecated: bool = False,
    ):
        self.parameter_name: str = parameter_name
        self.parameter_in: typing.Literal["query", "path"] = parameter_in
        self.required: bool = required
        self.deprecated: bool = deprecated
