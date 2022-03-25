import gzip
from typing import cast

from quart import Request, Response
from werkzeug.datastructures import ContentSecurityPolicy


async def compress(res: Response, req: Request) -> Response:
    GZIP = 'gzip'
    IDENTITY = 'identity'
    if GZIP in req.accept_encodings and (
        not res.content_encoding or res.content_encoding == IDENTITY
    ):
        data = res.get_data(as_text=False)
        try:
            data = await data
        except TypeError:
            data = cast(bytes, data)
        data_gz = gzip.compress(data)
        res.set_data(data_gz)
        res.content_encoding = GZIP
    return res


def remove_headers(res: Response) -> Response:
    del res.headers['Date']
    del res.headers['Expires']
    del res.headers['Last-Modified']
    del res.headers['Server']
    return res


def add_html_csp(res: Response) -> Response:
    if res.content_type and 'html' in res.content_type:
        res.content_security_policy = ContentSecurityPolicy()
        res.content_security_policy.default_src = "'self'"
    return res
