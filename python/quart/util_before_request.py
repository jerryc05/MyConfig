from http import HTTPStatus
from urllib.parse import urlparse

from quart import Response, redirect, request


def upgrade_http(port: 'int|None' = None) -> 'Response|None':
    if not request.is_secure:
        url = urlparse(request.url)
        url = url._replace(scheme='https')
        if port is not None:
            url = url._replace(netloc=f'{url.hostname}:{port}')
        code = HTTPStatus.MOVED_PERMANENTLY
        return redirect(location=url.geturl(), code=code)
    return None
