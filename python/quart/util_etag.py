import mimetypes
from base64 import b85encode
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

__DEFAULT_CONTENT_ENCODING = ''


@dataclass
class EtagContent:
    etag_unquoted: str
    content: 'bytes|None'


@dataclass
class EtagCache:
    stat: stat_result
    etag_unquoted: str
    content: 'bytes|None'


async def etag_of_path(
    p: Path, content_encoding: str = __DEFAULT_CONTENT_ENCODING
) -> EtagContent:
    cache = cast('dict[str,EtagCache]', getattr(etag_of_path, 'cache', {}))
    key = str((p.resolve(), content_encoding))
    res = cache.get(key)

    if res is not None and res.stat == p.stat():
        return EtagContent(res.etag_unquoted, content=res.content)

    async with async_open(p, 'rb') as f:
        content = await f.read()
    int_chksum = adler32(content)
    str_be_chksum = b85encode(int_chksum.to_bytes(4, 'big')).decode()
    res = EtagContent(str_be_chksum, content)
    cache[key] = EtagCache(
        p.stat(),
        res.etag_unquoted,
        content=None if len(content) > __MAX_CONTENT_SIZE_IN_CACHE else content,
    )
    return res


async def etag_file(
    req: Request, p: Path, content_encoding: str = __DEFAULT_CONTENT_ENCODING
) -> Response:
    etag = await etag_of_path(p, content_encoding)

    async def res_fn():
        if etag.content is not None:
            res = Response(etag.content, mimetype=mimetypes.guess_type(p.name)[0])
        else:
            res = await send_file(str(p), add_etags=False)
        res.headers.remove('Cache-Control')
        # [Expires] will be deleted in [util_after_request.remove_headers]
        return res

    return await etag_response(req, res_fn, etag.etag_unquoted, content_encoding)


async def etag_file_try_content_encoding(
    req: Request, p_br: Path, p: Path, content_encoding: str
) -> Response:
    if content_encoding in req.accept_encodings and p_br.exists():
        res = await etag_file(req, p_br, content_encoding)
    else:
        res = await etag_file(req, p)
    return res


async def etag_json(req: Request, obj: object, etag: str):
    async def res_fn():
        return jsonify(obj)

    return await etag_response(req, res_fn, etag)


async def etag_response(
    req: Request,
    res_fn: 'Callable[[],Coroutine[Any, Any, Response]]',
    etag_unquoted: str,
    content_encoding: str = __DEFAULT_CONTENT_ENCODING,
) -> Response:
    assert not etag_unquoted.endswith('"')
    if req.if_none_match.contains_raw(etag_unquoted):
        res = Response(response=b'', status=HTTPStatus.NOT_MODIFIED)
        res.headers.clear()
        logging.info(f'Request [{req.url}] cache hit by [etag]!')
    else:
        res = await res_fn()
        res.set_etag(etag_unquoted)
    if content_encoding:
        res.content_encoding = content_encoding
    return res
