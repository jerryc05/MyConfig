#!/usr/bin/env python3

from pprint import pp
import subprocess as sp
import os
import sys

PREALLOCATE_ARG = "--preallocate"
ARGS = [
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
    PREALLOCATE_ARG,
    "--safe-links",
    "--perms",
    "--sparse",
    "--inplace",
    "--delete-during",
    "--no-whole-file",
    "--skip-compress=jpg/jpeg/png/mp[34]/avi/mkv/xz/zip/gz/7z/bz2",
    "--info=progress2",
    *sys.argv[1:],
]


def xrsync():
    global ARGS

    p = sp.Popen(args=[*ARGS, "--dry-run"], stdout=sp.PIPE, stderr=sp.PIPE)
    if (
        p.wait() != 0
        and p.stderr
        and b"preallocation is not supported on this Client" in p.stderr.read()
    ):
        ARGS.remove(PREALLOCATE_ARG)
        p = sp.Popen(args=[*ARGS, "--dry-run"], stdout=sp.PIPE, stderr=sp.PIPE)
    p.wait()
    print("\n\n")
    pp(ARGS)
    print("-" * 10)

    if p.stdout:
        print(p.stdout.read().decode())
    print("-" * 10)
    if p.stderr:
        print(p.stderr.read().decode())
    print("-" * 20)

    confirm = input("\n\nContinue? ").strip()
    if confirm.lower() == "y" or (
        confirm.lower() == "" and input("\nContinue? (double confirm) ").__len__() >= 0
    ):
        return os.execlp("rsync", *ARGS)


if __name__ == "__main__":
    xrsync()
