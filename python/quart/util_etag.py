from http import HTTPStatus
from pathlib import Path
from typing import Any, Callable, Coroutine

from quart import Request, Response, jsonify, send_file


async def etag_file(req: Request, fp: Path) -> Response:
    async def res_fn():
        res = await send_file(str(fp), add_etags=False)
        res.headers.remove('Cache-Control')
        return res

    etag_unquoted = f'{fp.stat().st_mtime}{fp.stat().st_size}'
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
    else:
        resp = await res_fn()
        resp.set_etag(etag_unquoted)
    return resp