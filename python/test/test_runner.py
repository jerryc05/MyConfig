#!/usr/bin/env python3

# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# pyright:reportUnusedImport=false
from contextlib import suppress
from math import ceil, floor
import multiprocessing as mp
import os
from pathlib import Path
import shutil
import signal as sig
import subprocess as sp
import sys
import time
import typing as tp

from test_base import *


class MyTest(ParallelTest):
    @staticmethod
    def version() -> 'str|float':
        '''
        If you want to name your test's version, return it.
        '''
        return ParallelTest.version()

    @staticmethod
    def n_pools() -> int:
        '''
        Number of processes to run in parallel.
        '''
        return floor(ParallelTest.n_cores() * 2.5)

    def run(self, args: 'tuple[...]') -> 'tuple[bool, str, str, float]':
        '''
        This function will be executed in parallel.
        '''
        assert isinstance(args, tuple)
        test_name, result, reason = 'Sleep test', False, ''
        assert isinstance(test_name, str)
        start_t, time_limit, popens = float('-inf'), 2, tp.cast('list[sp.Popen[bytes]]', [])
        p(f'[{test_name}] started ...')
        try:
            self.upd_test_name(test_name)
            start_t, _ = time.time(), sig.alarm(
                time_limit
            )  # Only Unix  # use `signal.alarm(0)` to clear the alarm

            # TODO Begin here...
            import random

            n = random.random() * 2.5
            result = n <= 1
            test_name = 'testTrue' if result else 'testFalse'
            reason = 'Slept more than 1 sec'
            self.upd_test_name(test_name)

            # If you want to print something, don't forget to `align`
            p(f'{GLOBAL_VAR} {n}s ...', align='l')

            time.sleep(n)

            p(f'{n}s sleeping done!', align='r')

            # If you want a real-time process call:
            """
            proc = sp.Popen(('ping', 'localhost'), stdout=sp.PIPE, stderr=sp.PIPE)
            popens.append(proc)
            if not proc.stdout or not proc.stderr:
                reason = 'Cannot read stdout/stderr of subprocess'
            else:
                while ...:
                    line, poll = proc.stdout.readline(), proc.poll()
                    if not line and poll is not None:
                        if poll != 0:
                            result, reason = False, reason_from_code(poll, proc.stderr)
                        break  # Exited
                    # Do something below:
                    ...
            """

            # If you want a normal process call:
            '''
            try:
                stdout = sp.check_output(('ping', 'localhost'), stderr=sp.PIPE, timeout=time_limit)
            except sp.SubprocessError as e:
                result, reason, stdout, stderr = False, reason_from_code(e.returncode, e.stderr), e.stdout, e.stderr
            '''

        except TleErr:
            result, reason = False, f'Time limit {time_limit} sec excceeded'

        except:
            ex_t, ex_v, ex_tb = sys.exc_info()
            assert ex_t and ex_v and ex_tb
            result, reason = False, f'Exception: [{ex_t.__name__}], msg: [{ex_v}]'

        finally:
            sig.alarm(0)
            for x in popens:
                x.terminate()  # remember to kill/term processes
            self.upd_test_name(None)

        return (result, test_name, reason, time.time() - start_t)

    def schedule(self) -> 'tp.Iterator[tuple[tp.Callable[..., object], tuple[object, ...]]]':
        '''
        YIELD (func, args) pairs that need to run in parallel.
        '''
        global GLOBAL_VAR
        GLOBAL_VAR = 'Sleeping'
        for _ in range(22):
            yield (self.run, tuple())


if __name__ == '__main__':
    MyTest()()
