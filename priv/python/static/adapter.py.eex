import typing
from abc import ABC, abstractstaticmethod


class HTTPAdapter(ABC):
    """
    HTTP adapter to perform Torn API requests.

    `torngen_python_client` is a bring-your-own-networking (BYON) library. To avoid restricting the client
    to a specific HTTP library, ratelimiting implementation, etc. which requires usage of this client to
    include an implementation of this HTTP adapter.

    An implementation of the HTTP adapter will need to implement the following three functions. An example
    implementation of the HTTPAdapter can be found in `tests/conftest.py`.
    """

    @staticmethod
    @abstractstaticmethod
    def get(url: str, headers: dict = {}) -> typing.Any:
        """
        HTTP GET request handler.

        The implementation of this function will make HTTP GET requests against the specified URL with
        the provided headers. Any request handling functionality can be performed by the function
        such as ratelimiting.
        """
        raise NotImplementedError(
            "The HTTP adapter needs to be implemented by a library or application using this client."
        )

    @staticmethod
    @abstractstaticmethod
    def version() -> str:
        """
        Version of the HTTP library.

        The implementation of this function will return a string identifying the version of the HTTP
        library utilized in the implementation of the HTTP adapter.

        Example: `2.32.4`
        """
        raise NotImplementedError(
            "The HTTP adapter needs to be implemented by a library or application using this client."
        )

    @staticmethod
    @abstractstaticmethod
    def client_name() -> str:
        """
        Name of the HTTP library.

        The implementation of this function will return a string identifying the name of the HTTP
        library utilized in the implementation of the HTTP adapter.
        """
        raise NotImplementedError(
            "The HTTP adapter needs to be implemented by a library or application using this client."
        )
