#!/usr/bin/env python3

import re
import shutil
import subprocess as sp


def sep():
    print('\n\n' + ('-' * shutil.get_terminal_size((50, 10)).columns))


def main(acc_tok: str) -> bool:
    remote, br = sp.check_output(
        'git rev-parse --abbrev-ref --symbolic-full-name @{u}'.split()).strip().decode().split('/')

    if acc_tok:
        old_url = sp.check_output(f'git remote get-url {remote}'.split(),
                                  stderr=sp.STDOUT).strip().decode()
        new_url = re.sub(r'x-access-token:.+?@', f'x-access-token:{acc_tok}@', old_url)

        sp.check_call(f'git remote set-url {remote} {new_url}'.split())
        sep()

    sp.check_call(f'git fetch {remote} {br} --depth=1'.split())
    sep()

    status_res = sp.check_output('git status -uno'.split(), stderr=sp.STDOUT).strip().decode()
    print(status_res)
    sep()

    if ('up to date' in status_res):
        print('No new commits. Quit.')
        sep()
        return False

    sp.check_call('git reset --hard @{u}'.split())
    sep()

    return True
