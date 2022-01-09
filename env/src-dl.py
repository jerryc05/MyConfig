#!/usr/bin/env python3

import re
import subprocess as sp
import tarfile
from inspect import stack
from pathlib import Path
from sys import argv
from typing import cast
from urllib.request import urlopen, urlretrieve


def main():
    if argv[1] == 'nano':
        if argv[2] == '--dist':
            nano_dist()
        elif argv[2] == '--git':
            nano_git()
        else:
            print('Usage: nano [--dist|--git]')


def __dl_file(url: str, dest: Path):
    def reporthook(count: int, blk_sz: int, tot_sz: int):
        len_sz = len(str(tot_sz))
        downloaded = count * blk_sz
        print(end=f"\r{str(downloaded):>{len_sz}}/{tot_sz} {downloaded*100/tot_sz:.3f}%")

    dest.parent.mkdir(parents=True, exist_ok=True)
    print(f'Downloading {url}')
    dest_, headers = urlretrieve(url, dest, reporthook)
    print()
    print(f'Downloaded to {dest_}')
    assert Path(dest_) == dest
    return dest, headers


def __untar_file(file_p: Path, untar_p: Path):
    with tarfile.open(file_p) as f:
        print(f'Untarring     {file_p}')
        f.extractall(untar_p)
        print(f'Untarred to   {untar_p}')


def nano_dist():
    BASE_URL = 'https://nano-editor.org/dist/latest/'
    dl_dir = Path(__file__).parent / stack()[0].function

    with urlopen(BASE_URL) as url:
        html = url.read().decode('utf8')
    filename_re = re.search(r'nano-[\d\.]+\.tar\.xz', html)
    if filename_re is None:
        raise Exception('Could not find filename!')
    else:
        filename = filename_re.group()

    xz_url = f"{BASE_URL}{filename}"
    dl_dest = dl_dir / filename
    file_p, _headers = __dl_file(xz_url, dl_dest)
    __untar_file(file_p, file_p.parent)

    cd_dest = next(file_p.parent.rglob('configure')).parent
    print(
        f'''
    cd {cd_dest}
    ./configure --prefix=$HOME/.local
    make
    make install
    '''
    )


def nano_git():
    dl_dest = Path(__file__).parent / stack()[0].function
    sp.check_call(
        f'git clone git://git.savannah.gnu.org/nano.git {dl_dest} --depth=1'.split(' ')
    )

    cd_dest = next(Path(dl_dest).rglob('autogen.sh')).parent
    print(
        f'''
    cd {cd_dest}
    ./autogen.sh
    ./configure --prefix=$HOME/.local
    make
    make install
    '''
    )


def ncurses_dev():
    filename = 'ncurses.tar.gz'
    URL = f'https://invisible-island.net/datafiles/current/{filename}'
    dl_dir = Path(__file__).parent / stack()[0].function
    dl_dest = dl_dir / filename

    file_p, _headers = __dl_file(URL, dl_dest)
    __untar_file(file_p, file_p.parent)


if __name__ == "__main__":
    main()
