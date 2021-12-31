import logging

from colorama import Fore, Style, init

init()


class MyLogFmt(logging.Formatter):
    FMT_STR = (
        "[%(asctime)s] [%(process)d] [%(levelname)8s] [%(processName)s"
        " %(filename)s:%(lineno)d] %(message)s"
    )
    DATE_FMT = '%m-%d-%YT%H:%M:%S%z'
    DFT_FMT = f'{Style.RESET_ALL}{FMT_STR}'
    FORMATS = {
        logging.DEBUG: f'{Fore.CYAN}{FMT_STR}{Style.RESET_ALL}',
        logging.INFO: f'{Fore.MAGENTA}{FMT_STR}{Style.RESET_ALL}',
        logging.WARNING: f'{Fore.YELLOW}{FMT_STR}{Style.RESET_ALL}',
        logging.ERROR: f'{Fore.RED}{FMT_STR}{Style.RESET_ALL}',
        logging.CRITICAL: f'{Fore.RED}{Style.BRIGHT}{FMT_STR}{Style.RESET_ALL}',
    }

    def format(self, record: 'logging.LogRecord'):
        # record.asctime = self.formatTime(record, __class__.DEFAULT_DATE_FMT)
        # print(self._style._fmt)
        # print(self.usesTime())
        # formatter = __class__.FORMATS.get(record.levelno, __class__.DEFAULT_FMTTER)
        # return formatter.format(record)
        self.__init__(
            fmt=__class__.FORMATS.get(record.levelno, __class__.DFT_FMT),
            datefmt=__class__.DATE_FMT,
        )
        return super().format(record)


logging.basicConfig(level=logging.DEBUG)
logging.getLogger().handlers[0].setFormatter(MyLogFmt())
logging.debug('123')
logging.info('123')
logging.warning('123')
logging.error('123')
logging.critical('123')
