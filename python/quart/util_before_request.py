from quart import Response, redirect, request
from http import HTTPStatus


def upgrade_http() -> 'Response|None':
    if not request.is_secure:
        url = request.url.replace('http://', 'https://', 1)
        code = HTTPStatus.MOVED_PERMANENTLY
        return redirect(location=url, code=code)
