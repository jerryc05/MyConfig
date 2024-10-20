#!/usr/bin/env python3

from pathlib import Path
from pprint import pp
import subprocess as sp
import sys
import shutil

from xrsync import xrsync


def gitrsync():
    sys.argv.append("--exclude=.git/")
    git = shutil.which("git")
    if git:
        git_excluded = []

        if Path(sys.argv[1]).is_dir():
            args = [
                git,
                (
                    "-C"
                    # [c]urrent directory in which git is called
                ),
                sys.argv[1],
                "ls-files",
                (
                    "-z"
                    # Don't quote and escape utf8; use \0 to separate filenames and keep utf8
                ),
                (
                    "-o"  # [o]ther (not tracked)
                ),
                (
                    "-i"  # [i]gnored
                ),
                (
                    "--exclude-standard"
                    #  Exclude git-ignored files (respect .gitignore, ...)
                ),
                (
                    "--directory"  # Use directory name if everything is ignored inside
                ),
            ]
            print("\n" + " ".join([f"'{x}'" for x in args]) + "\n")
            git_excluded = [x for x in sp.check_output(args).decode().split("\0") if x]
            print("\n")
            pp(git_excluded)
            print("\n")

        for d in git_excluded:
            d = d.strip()
            if d:
                sys.argv.append(
                    f"--exclude={d}",
                )

    return xrsync()


if __name__ == "__main__":
    if sp.call(["git", "check-ignore", sys.argv[1]]) == 0:
        print(f"Path is ignored by git! Quitting ...\n\t{sys.argv[1]}")
        exit()
    gitrsync()
