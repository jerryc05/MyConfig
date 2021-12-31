from quart import Response, redirect, request


def upgrade_http() -> 'Response|None':
    if not request.is_secure:
        url = request.url.replace('http://', 'https://', 1)
        from http import HTTPStatus

        code = HTTPStatus.MOVED_PERMANENTLY
        return redirect(location=url, code=code)
