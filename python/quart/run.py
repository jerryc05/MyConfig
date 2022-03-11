#!/usr/bin/env python3

import socket
from importlib.util import find_spec
from multiprocessing import cpu_count
from os import getenv
from pathlib import Path
from ssl import SSLContext, TLSVersion
from typing import Iterable

from hypercorn.config import Config
from hypercorn.run import run

from util_logging import logging

if __name__ == '__main__':
    DEBUG = bool(int(getenv('DEBUG', 1)))
    DOMAIN = ''  # TODO
    INSECURE_BINDS = ['0.0.0.0:80']
    BINDS = ['0.0.0.0:443']
    QUIC_BINDS = BINDS
    EXTERNAL_QUIC_PORTS: 'Iterable[int]|None' = None
    APP = 'app'

    CERT_DIR = Path.home() / '.acme.sh' / f'{DOMAIN}_ecc'
    assert CERT_DIR.is_dir()

    FULLCHAIN_CERT = CERT_DIR / 'fullchain.cer'
    assert FULLCHAIN_CERT.is_file()
    CERT_KEY = CERT_DIR / f'{DOMAIN}.key'
    assert CERT_KEY.is_file()

    class MyConfig(Config):
        def create_ssl_context(self) -> 'SSLContext|None':
            ctx = super().create_ssl_context()
            if ctx is not None:
                ctx.minimum_version = TLSVersion.TLSv1_3
            return ctx

        def _set_quic_addresses(self, sockets: 'list[socket.socket]') -> None:
            super()._set_quic_addresses(sockets)
            if EXTERNAL_QUIC_PORTS:
                config._quic_addresses = [(None, x) for x in EXTERNAL_QUIC_PORTS]
                logging.warning('_quic_addresses changed to [%s]!', self._quic_addresses)

    config = MyConfig()

    if INSECURE_BINDS:
        config.insecure_bind = INSECURE_BINDS
    config.bind = BINDS
    config.quic_bind = QUIC_BINDS

    config.certfile = str(FULLCHAIN_CERT)
    config.keyfile = str(CERT_KEY)

    if find_spec('uvloop'):
        config.worker_class = 'uvloop'
    else:
        logging.warning('')
        logging.warning('uvloop not found, using default worker class!')
        logging.warning('')

    config.debug = DEBUG

    if not config.debug:
        workers = cpu_count()
    else:
        workers = 1
        config.use_reloader = True
    config.workers = workers

    config.application_path = APP

    try:
        run(config)
    except asyncio.exceptions.TimeoutError:
        pass
