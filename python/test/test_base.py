#!/usr/bin/env python3

# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

from abc import ABC, abstractmethod
from contextlib import suppress
from math import ceil, floor
import multiprocessing as mp
from multiprocessing.pool import AsyncResult
import os
from pathlib import Path
from queue import Queue
import re
import shutil
import signal as sig
import sys
import time
import threading as thr
import typing as tp

DEF_TERM_SIZE, FILE_PATH, DBG_MODE = (
    (60, -1),
    Path(__file__).parent.resolve(),
    os.environ.get('DBG'),
)
SIG_DICT = {v: k for k, v in sig.__dict__.items() if k.startswith('SIG')}


def reason_from_code(code: int, stderr: 'tp.IO[bytes]|None' = None) -> str:
    desc = f"{code}"
    try:
        desc += f" {SIG_DICT[-code]} ({sig.strsignal(-code)})"
    except (KeyError, ValueError):
        try:
            desc += f" {SIG_DICT[code-128]} ({sig.strsignal(code-128)})"
        except (KeyError, ValueError):
            pass

    rv = f'Exit code: [{desc}]'
    if stderr is not None:
        rv += f', stderr: [{stderr.read().strip().decode()}]'
    return rv


class Print:
    CLR_ALL, BOLD, DIM, ITALIC, UNDERLINE, INVERT, NORMAL = 0, 1, 2, 3, 4, 7, 22
    BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, CLR_COLOR = (
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        39,
    )
    (
        BLACK_BG,
        RED_BG,
        GREEN_BG,
        YELLOW_BG,
        BLUE_BG,
        MAGENTA_BG,
        CYAN_BG,
        WHITE_BG,
        CLR_COLOR_BG,
    ) = (40, 41, 42, 43, 44, 45, 46, 47, 49)
    L_BLACK, L_RED, L_GREEN, L_YELLOW, L_BLUE, L_MAGENTA, L_CYAN, L_WHITE = (
        90,
        91,
        92,
        93,
        94,
        95,
        96,
        97,
    )
    (
        L_BLACK_BG,
        L_RED_BG,
        L_GREEN_BG,
        L_YELLOW_BG,
        L_BLUE_BG,
        L_MAGENTA_BG,
        L_CYAN_BG,
        L_WHITE_BG,
    ) = (100, 101, 102, 103, 104, 105, 106, 107)
    CUR_UP = '\x1b[00F'

    def __init__(self) -> None:
        for name in dir(self):
            if isinstance(getattr(self, name), int):
                setattr(self, name, f'\x1b[{getattr(self, name):02}m')

    def __call__(
        self,
        *values: object,
        sep: str = '',
        end: str = '\n',
        file: 'tp.TextIO' = sys.stdout,
        flush: bool = True,
        align: 'tp.Literal["l"]|tp.Literal["c"]|tp.Literal["r"]|None' = None,
        fill_ch: str = ' ',
    ) -> None:
        assert align in (None, 'l', 'c', 'r')
        lck = tp.cast('thr.RLock|None', globals()['lock'])
        if align not in ('l', 'c', 'r'):
            if lck is not None:
                lck.acquire()
            print(*values, sep=sep, end=f'{end}{self.CLR_ALL}', file=file, flush=flush)
            if lck is not None:
                lck.release()
        else:
            cols = get_cols()
            if align == 'l':
                if lck is not None:
                    lck.acquire()
                print(
                    f'{" "*cols}\r',
                    *values,
                    sep=sep,
                    end=f'{end}{self.CLR_ALL}',
                    file=file,
                    flush=flush,
                )
                if lck is not None:
                    lck.release()
            else:
                orient = '^' if align == 'c' else '>'
                s = sep.join(list(map(str, values)))
                sz = cols + len(s) - strlen(s)
                s = f'{s:{fill_ch[0]}{orient}{sz}}'
                if lck is not None:
                    lck.acquire()
                print(s, sep=sep, end=f'{end}{self.CLR_ALL}', file=file, flush=flush)
                if lck is not None:
                    lck.release()


p = Print()


class TleErr(RuntimeError):
    @staticmethod
    # pyright:reportGeneralTypeIssues=false,reportUnknownParameterType=false
    def raise_(signum: int, frame: 'sig.FrameType|None') -> tp.NoReturn:
        raise TleErr


def find_file(name: 'Path|str', parent: bool = True) -> 'Path|None':
    path_ = Path(name)
    if path_.is_file():
        return path_.resolve()
    path_ = FILE_PATH.parent if parent else FILE_PATH
    g_res = tuple(x for x in path_.rglob(str(name)))
    if not g_res:
        return None
        # raise FileNotFoundError(f'{p.L_RED}Cannot find file [{p.BOLD}{name}{p.NORMAL}]!{p.CLR_ALL}')
    elif len(g_res) > 1:
        s = f'{p.L_RED}Ambiguous files:'
        for i, x in enumerate(g_res):
            s += f'\n{i+1}) \t{x}'
        raise RuntimeError(f'{s}{p.CLR_ALL}')
    return Path(g_res[0]).resolve()


def strlen(s: str) -> int:
    return len(s) - len('\x1b[???') * s.count('\x1b[')


def get_cols() -> int:
    return shutil.get_terminal_size(DEF_TERM_SIZE).columns or DEF_TERM_SIZE[0]


refresh_time = 1 / 30


class ParallelTest(ABC):
    _n_cores: 'int|None' = None

    @staticmethod
    def version() -> 'str|float':
        return 0

    @abstractmethod
    def schedule(self) -> 'tp.Iterator[tuple[tp.Callable[..., object], tuple[object, ...]]]':
        ...

    @staticmethod
    def n_cores() -> int:
        if not ParallelTest._n_cores:
            ParallelTest._n_cores = os.cpu_count() or 6
            with suppress(AttributeError):
                ParallelTest._n_cores = len(os.sched_getaffinity(0))
        return ParallelTest._n_cores

    @staticmethod
    def n_pools() -> int:
        return floor(ParallelTest.n_cores() * 1.5)

    def __init__(self) -> None:
        global lock
        try:
            mp.set_start_method('fork')  # Only Unix
        except RuntimeError:
            ...
        except ValueError:
            raise NotImplementedError(
                f'{p.L_RED}Current OS does not support {p.BOLD}fork(){p.NORMAL}!{p.CLR_ALL}'
            )

        if 'utf' not in sys.stdout.encoding.lower():
            if not os.environ.get(f'_RERUN_{os.path.basename(__file__)}'):
                os.environ[f'_RERUN_{os.path.basename(__file__)}'] = '1'
                os.environ['PYTHONIOENCODING'] = 'utf8'

                os.execv(sys.executable, [sys.executable] + sys.argv)
            else:
                raise RuntimeError(f'{p.L_RED}Failed to set UTF-8 encoding!{p.CLR_ALL}')

        lock = tp.cast('thr.RLock|None', mp.RLock()) if self.n_pools() > 1 else None
        ver = self.version()
        if not isinstance(ver, str):
            ver = f'v{ver}'
        p(
            f"{p.L_CYAN}{ver}\t# pools: {p.BOLD}{self.n_pools()}\t{p.NORMAL}Term cols:"
            f" {p.BOLD}{get_cols()}"
        )

    @staticmethod
    def upd_test_name(val: 'str|None') -> None:  # bug fix for MacOS on 20+ parallel
        d = q.get()
        d[mp.current_process().name] = val
        q.put(d)

    @staticmethod
    def _init_pool(lck: 'thr.RLock|None', q_: 'mp.Queue[dict[str,str|None]]') -> None:
        global lock, q
        lock, q = lck, q_

    def __call__(self) -> None:
        global lock, q
        tasks, q = tuple(self.schedule()), tp.cast(
            'mp.Queue[dict[str,str|None]]', (mp.Queue() if self.n_pools() > 1 else Queue())
        )
        q.put_nowait({})
        assert tasks

        # pyright:reportUnknownArgumentType=false,reportUnknownMemberType=false
        sig.signal(sig.SIGALRM, TleErr.raise_)  # use signal.SIG_IGN as handler to ignore

        eq_ch = '\u2550'
        hint, ul, ur, ll, lr, hs, vs = (
            '>>> Running',
            '\u250c',
            '\u2510',
            '\u2514',
            '\u2518',
            '\u2500',
            '\u2502',
        )
        prog_bars = (
            '\u00b7',
            '\u258f',
            '\u258e',
            '\u258d',
            '\u258c',
            '\u258b',
            '\u258a',
            '\u2589',
            '\u2588',
        )

        if self.n_pools() > 1:
            pool = mp.Pool(min(self.n_pools(), len(tasks)), self._init_pool, (lock, q))
            rets: 'list[AsyncResult[tuple[bool, str, str, float]]]' = []

        else:
            pool = None
            rets: 'list[tuple[bool, str, str, float]]' = []

        succ, fail = tp.cast('list[list[tuple[str, str, float]]]', ([], []))
        print(end=f'{p.L_MAGENTA}{p.BOLD}')
        p(' START! ', align='c', fill_ch=eq_ch)

        if self.n_pools() > 1:
            assert pool is not None
            for fn, args in tasks:
                rets.append(pool.apply_async(fn, args))
        else:

            class FakeAsyncResult:
                def __init__(
                    self, fn: 'tp.Callable[..., object]', args: 'tuple[object, ...]'
                ) -> None:
                    self.fn = fn
                    self.args = args

                def get(self, timeout: int = 0) -> 'tuple[bool, str, str, float]':
                    return self.fn(self.args)

            for fn, args in tasks:
                rets.append(FakeAsyncResult(fn, args))

        n_rets, digit_of_n_rets, last_time, need_upd = (
            len(rets),
            len(str(len(rets))),
            None,
            False,
        )
        proc_tasks = q.get()
        q.put(proc_tasks)

        def upd() -> None:
            cols = get_cols()
            cols_ = cols - strlen(hint) - 17 - 2 * digit_of_n_rets
            s = f'Last task finished in {p.L_CYAN}{res[-1]:.3f} s{p.CLR_ALL}: {p.BOLD}'
            if res[0]:
                s += tp.cast(str, p.L_GREEN)
                s2 = f' {p.NORMAL}... OK!'
            else:
                s += tp.cast(str, p.L_RED)
                s2 = f' {p.NORMAL}... ERR!'
            s += f'{res[1][:cols-strlen(s)-strlen(s2)]}{s2}'

            percent = 1 - len(rets) / n_rets
            p1 = floor(cols_ * percent)
            p2 = floor((cols_ * percent - p1) * len(prog_bars))
            p3 = cols_ - p1 - (1 if p2 else 0)
            b = (
                f'\r{hint} '
                f' {prog_bars[-1]*p1}{prog_bars[p2] if p2 else ""}{prog_bars[0]*p3} '
                f' {percent:7.2%} - '
                f'{n_rets-len(rets):{digit_of_n_rets}}/{n_rets:{digit_of_n_rets}}'
                f'{p.CUR_UP*(4+len(proc_tasks))}\r'
            )
            max_proc_name = len(max(proc_tasks.keys(), key=len))

            if lock is not None:
                lock.acquire()
            p(align='l')
            p(align='l')
            for p_name, t_name in proc_tasks.items():
                p(
                    f'{p.L_CYAN}{p_name:{max_proc_name}} ('
                    + (f'Running): {t_name}' if t_name is not None else 'Idle)'),
                    align='l',
                )
            p(align='l')
            p(s, align='l')
            p(end=b, align='l')
            if lock is not None:
                lock.release()

        while rets:
            for ret in rets[:]:
                try:
                    res = tp.cast('AsyncResult[tuple[bool, str, str, float]]', ret).get(
                        timeout=0
                    )
                    (succ if res[0] else fail).append(res[1:])
                    rets.remove(ret)

                    if last_time and time.time() - last_time < refresh_time:
                        need_upd = True
                        continue

                    last_time, need_upd = time.time(), False
                    proc_tasks = q.get()
                    q.put(proc_tasks)
                    upd()
                except mp.TimeoutError:
                    if last_time and time.time() - last_time >= refresh_time and need_upd:
                        last_time, proc_tasks = time.time(), q.get()
                        need_upd, _ = False, q.put(proc_tasks)
                        upd()

        lock = None
        upd()
        p('\n' * (3 + len(proc_tasks)), align='l')

        if succ or fail:
            print(end=f'{p.L_MAGENTA}{p.BOLD}')
            p(' SUMMARY ', align='c', fill_ch=eq_ch)
            succ.sort()
            fail.sort()
            digit, sec_digit = len(str(max(len(succ), len(fail)))), 4
            for i, (x, r, t) in enumerate(succ):
                r = '\t (' + r + ')' if r else ''
                p(
                    f'{p.L_GREEN}{i+1:>{digit}}. OK'
                    f' ({t:{sec_digit}.{max(0,sec_digit-1-len(str(ceil(t))))}f} s) \u2714'
                    f' {p.BOLD}{x}{p.NORMAL}{r}',
                )
            sig_re = re.compile(r'SIG\w+ *\(.+?\)')
            for i, (x, r, t) in enumerate(fail):
                re_s = sig_re.search(r)
                if re_s:
                    s, e = re_s.span()
                    r_ = r[s:e]
                    r = (
                        f'{r[:s]}{p.L_CYAN}{r_[:r_.find(" ")]}{p.L_YELLOW}{r_[r_.find(" "):]}{p.L_RED}{r[e:]}'
                    )
                p(
                    f'{p.L_RED}{i+1:>{digit}}.ERR'
                    f' ({t:{sec_digit}.{max(0,sec_digit-1-len(str(ceil(t))))}f} s) \u274C'
                    f' {p.BOLD}{x}{p.NORMAL}\t ({r})'
                )
            res = (
                f'{p.L_GREEN}PASSED: {p.BOLD}{len(succ)}{p.NORMAL}  {p.L_RED}FAILED:'
                f' {p.BOLD}{len(fail)}'
            )
            res_len = strlen(res)

            ul, ur, ll, lr, hs, vs = '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
            p(f'{p.L_CYAN}{ul}{hs*(res_len+2)}{ur}')
            p(f'{p.L_CYAN}{vs} {p.CLR_ALL}{res}{p.L_CYAN} {vs}')
            p(f'{p.L_CYAN}{ll}{hs*(res_len+2)}{lr}')

        print(end=f'{p.L_MAGENTA}{p.BOLD}')
        p(' DONE! ', align='c', fill_ch=eq_ch)
