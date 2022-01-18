import logging
from datetime import datetime

from colorama import Fore, Style, init

init()


class MyLogFmt(logging.Formatter):
    FMT_STR = (
        "[%(asctime)s] [%(levelname)8s] [%(process)d %(processName)s] [%(thread)d"
        " %(threadName)s] [%(filename)s:%(lineno)d] %(message)s"
    )
    DATE_FMT = r'%Y-%m-%d_%H:%M:%S.%f%z'
    DFT_FMT = f'{Style.RESET_ALL}{FMT_STR}'
    FORMATS = {
        logging.DEBUG: f'{Fore.CYAN}{FMT_STR}{Style.RESET_ALL}',
        logging.INFO: f'{Fore.MAGENTA}{FMT_STR}{Style.RESET_ALL}',
        logging.WARNING: f'{Fore.YELLOW}{FMT_STR}{Style.RESET_ALL}',
        logging.ERROR: f'{Fore.RED}{FMT_STR}{Style.RESET_ALL}',
        logging.CRITICAL: f'{Fore.RED}{Style.BRIGHT}{FMT_STR}{Style.RESET_ALL}',
    }

    def formatTime(self, record: 'logging.LogRecord', datefmt: 'str|None' = None):
        dt = datetime.fromtimestamp(record.created).astimezone()
        if datefmt:
            s = dt.strftime(datefmt)
        else:
            s = dt.strftime(self.default_time_format)
            if self.default_msec_format:
                s = self.default_msec_format % (s, record.msecs)
        return s

    def format(self, record: 'logging.LogRecord'):
        self.__init__(
            fmt=__class__.FORMATS.get(record.levelno, __class__.DFT_FMT),
            datefmt=__class__.DATE_FMT,
        )
        return super().format(record)


def example():
    logging.basicConfig(level=logging.DEBUG)
    for x in logging.getLogger().handlers:
        x.setFormatter(MyLogFmt())
    logging.debug('123')
    logging.info('123')
    logging.warning('123')
    logging.error('123')
    logging.critical('123')
