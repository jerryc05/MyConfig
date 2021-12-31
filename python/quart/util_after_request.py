import gzip
from typing import cast

from quart import Response, request


async def compress(res: Response) -> Response:
    GZIP = 'gzip'
    if GZIP in request.accept_encodings and GZIP != res.content_encoding:
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
