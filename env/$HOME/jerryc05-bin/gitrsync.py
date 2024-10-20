#!/usr/bin/env python3

import subprocess as sp
import sys
import shutil

from xrsync import xrsync


def gitrsync():
    sys.argv.append("--exclude=.git/")
    git = shutil.which("git")
    if git:
        git_excluded = (
            sp.check_output([
                "git",
                "-C",
                sys.argv[1],
                "ls-files",
                "-z",
                "-o",
                "-i",
                "--exclude-standard",
                "--directory",
            ])
            .decode()
            .split("\0")
        )
        for d in git_excluded:
            d = d.strip()
            if d:
                sys.argv.append(
                    f"--exclude={d}",
                )
    return xrsync()


if __name__ == "__main__":
    gitrsync()
