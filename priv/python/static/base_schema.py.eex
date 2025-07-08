import inspect
import textwrap
import types
import typing
import warnings
from abc import ABC, abstractstaticmethod


class BaseSchema(ABC):
    """
    Base representation of an Torn APIv2 response schema.

    This base class will be used to parse API responses by the type hints and dataclasses
    used for the schema.
    """

    @staticmethod
    @abstractstaticmethod
    def parse(data: dict):
        raise NotImplementedError("This should be implemented by the schema")

    @staticmethod
    def parse(data: typing.Any, type_hints: typing.Type[typing.Any]) -> typing.Any:
        origin = typing.get_origin(type_hints)
        args = typing.get_args(type_hints)

        if isinstance(type_hints, type) and issubclass(type_hints, dict):
            # Should only be typing.TypedDict
            if not hasattr(type_hints, "__annotations__"):
                # Fallback for missing annotations
                warnings.warn(
                    f"Potential TypedDict {type_hints} missing __annotations__"
                )
                return data
            elif not isinstance(data, dict):
                raise TypeError(
                    f"Expected type dict for TypedDict but got {type(data)}"
                )

            parsed_dict = {}

            for key, field_type in type_hints.__annotations__.items():
                try:
                    parsed_dict[key] = BaseSchema.parse(data.get(key), field_type)
                except Exception as e:
                    warnings.warn(
                        f"Unable to parse key {key} of TypedDict {type_hints} due to {e}"
                    )
                    parsed_dict[key] = None

            return parsed_dict

        if hasattr(type_hints, "__supertype__"):
            # should only be NewType
            return BaseSchema.parse(data, type_hints.__supertype__)

        if origin is None and data is None:
            return None

        if isinstance(type_hints, type):
            if type_hints in (int, float, str, bool):
                # We should just cast primitives since they aren't wrapped and don't have to
                # be parsed individually
                return type_hints(data)

            parse_method = getattr(type_hints, "parse", None)
            if (
                parse_method is not None
                and callable(parse_method)
                and len(inspect.signature(parse_method).parameters) == 1
            ):
                # Without getting the count of parameters in the parse method, the function
                # call may be upon this static parse method instead of the parse class method
                return parse_method(data)

            # We should fallback to attempting to cast the value if there isn't a parse method
            return type_hints(data)

        if origin is typing.Union or origin is types.UnionType:
            for arg in args:
                try:
                    return BaseSchema.parse(data, arg)
                except Exception:
                    continue

            raise TypeError(f"Data does not match any type in union {args}")

        if origin is typing.Literal and data in args:
            return data
        elif origin is typing.Literal:
            args_string = textwrap.shorten(", ".join(args), width=30, placeholder="...")
            raise ValueError(
                f"Data does not match any value in the literal with values {args_string}"
            )

        if origin in (list, typing.List):
            if not isinstance(data, list):
                raise TypeError(f"Expected type list but got {type(data)}")

            inner_type = args[0]
            return [BaseSchema.parse(item, inner_type) for item in data]

        raise TypeError(f"Unsupported type hint {type_hints}")
