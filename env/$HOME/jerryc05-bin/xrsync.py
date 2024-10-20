#!/usr/bin/env python3

from pprint import pp
import subprocess as sp
import os
import sys


def xrsync():
    args = (
        "rsync",
        (
            "-a"  # [a]rchive mode; equals -rlptgoD (no -H,-A,-X)
        ),
        (
            "-h"  # [h]uman-readable format output (for numbers)
        ),
        (
            "-P"
            # [p]reserve partially transferred files + show progress during transfer
        ),
        (
            "-vv"
            # [v]erbose
        ),
        (
            "-z"
            # [z]ip: compress file data during the transfer
        ),
        "--relative",
        (
            "--mkpath"
            # Added in 3.2.3
        ),
        "--safe-links",
        "--perms",
        "--preallocate",
        "--sparse",
        "--inplace",
        "--delete-during",
        "--no-whole-file",
        "--skip-compress=jpg/jpeg/png/mp[34]/avi/mkv/xz/zip/gz/7z/bz2",
        "--info=progress2",
        *sys.argv[1:],
    )
    pp(args)
    sp.call(args=[*args, "--dry-run"])

    confirm = input("\n\nContinue? ").strip()
    if confirm.lower() == "y" or (
        confirm.lower() == "" and input("\nContinue? (double confirm) ").__len__() >= 0
    ):
        return os.execlp("rsync", *args)


if __name__ == "__main__":
    xrsync()
