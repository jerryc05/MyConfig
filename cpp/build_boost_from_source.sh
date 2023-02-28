#!/usr/bin/env bash

set -euxo pipefail

build() {
    export CFLAGS="-w -march=native -Ofast -std=gnu++20"
    export CXXFLAGS="$CFLAGS"
    ./bootstrap.sh --with-python=`which python3` --with-icu --without-libraries=mpi
    ./b2 -j`nproc` cflags="$CFLAGS" cxxflags="$CXXFLAGS"
}



###### THIS IS FOR NEW INSTALLATION
git clone --single-branch --branch master --depth=1 --recurse-submodules --shallow-submodules https://github.com/boostorg/boost.git
cd boost

build

cat <<<EOF >>~/.bashrc


export BOOST_ROOT=`pwd`  # for cmake" >>~/.bashrc

export CPATH=`pwd`:\$CPATH
export LIBRARY_PATH=`pwd`/stage/lib:\$LIBRARY_PATH

EOF



###### THIS IS FOR UPDATE
cd boost
git submodule foreach | cut -d ' ' -f 2 | xargs -I@ -P `nproc` sh -c 'cd @ && git fetch --depth 1 && git reset --hard FETCH_HEAD'    

build
