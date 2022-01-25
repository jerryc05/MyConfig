import mimetypes
from dataclasses import dataclass
from http import HTTPStatus
from os import stat_result
from pathlib import Path
from typing import Any, Callable, Coroutine, cast
from zlib import adler32

from aiofiles import open as async_open
from quart import Request, Response, jsonify, send_file

from util_logging import logging

__MAX_CONTENT_SIZE_IN_CACHE = 4096


@dataclass
class EtagContent:
    etag_unquoted: str
    content: 'bytes|None'


@dataclass
class EtagCache:
    stat: stat_result
    etag_unquoted: str
    content: 'bytes|None'


async def etag_of_path(p: Path) -> EtagContent:
    cache = cast('dict[str,EtagCache]', getattr(etag_of_path, 'cache', {}))
    key = str(p.resolve())
    res = cache.get(key)

    if res is not None and res.stat == p.stat():
        return EtagContent(res.etag_unquoted, content=res.content)

    async with async_open(p, 'rb') as f:
        content = await f.read()
        res = EtagContent(str(adler32(content)), content)
        cache[key] = EtagCache(
            p.stat(),
            res.etag_unquoted,
            content=None if len(content) > __MAX_CONTENT_SIZE_IN_CACHE else content,
        )
        return res


async def etag_file(req: Request, p: Path) -> Response:
    etag = await etag_of_path(p)

    async def res_fn():
        if etag.content is not None:
            res = Response(etag.content, mimetype=mimetypes.guess_type(p.name)[0])
        else:
            res = await send_file(str(p), add_etags=False)
        res.headers.remove('Cache-Control')
        # Expires will be deleted in `after_request.remove_headers`
        return res

    etag_unquoted = etag.etag_unquoted
    return await etag_response(req, res_fn, etag_unquoted)


async def etag_json(req: Request, obj: object, etag: str):
    async def res_fn():
        return jsonify(obj)

    return await etag_response(req, res_fn, etag)


async def etag_response(
    req: Request, res_fn: 'Callable[[],Coroutine[Any, Any, Response]]', etag_unquoted: str
) -> Response:
    assert not etag_unquoted.endswith('"')
    if req.if_none_match.contains_raw(etag_unquoted):
        resp = Response(response=b'', status=HTTPStatus.NOT_MODIFIED)
        resp.headers.clear()
        logging.info(f'Request [{req.url}] cache hit by [etag]!')
    else:
        resp = await res_fn()
        resp.set_etag(etag_unquoted)
    return resp
