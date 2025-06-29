import typing
import warnings

from base_path import Path


class BaseQuery(object):
    def __init__(self) -> typing.Self:
        self.selections: typing.List[Path] = set()
        self.parameters: typing.Dict[str, typing.Any] = {}
        self.api_key = None

    def select(self, *args: typing.List[Path]) -> typing.Self:
        self.selections.update(args)
        return self

    def key(self, api_key: str) -> typing.Self:
        self.api_key = api_key
        return self

    def get(self, adapter=None) -> typing.Self:
        # TODO: Implement this
        return self

    def parse(self):
        return NotImplemented

    def __getattr__(
        self, parameter_name
    ) -> typing.Callable[typing.Any, typing.Self]:
        def setter_method(value: typing.Any) -> typing.Any:
            if not self.__validate_parameter(parameter_name, value):
                return self

            self.parameters[parameter_name] = value
            return self

        return setter_method

    def __validate_parameter(
        self, parameter_name: str, parameter_value: typing.Any
    ) -> bool:
        path: Path
        for path_name, path in self.__class__.__dict__.items():
            if path_name.startswith("__"):
                continue
            elif not isinstance(path, Path):
                continue
            elif parameter_name not in path.parameters:
                continue

            return True

        warnings.warn(
            f"Invalid parameter {parameter_name} for selected paths", RuntimeWarning
        )
        return False
