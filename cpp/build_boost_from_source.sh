#!/usr/bin/env bash

set -euxo pipefail

git clone --single-branch --branch master --depth=1 --recurse-submodules --shallow-submodules https://github.com/boostorg/boost.git
# git clone --single-branch --branch master --depth=1 https://github.com/boostorg/boost.git
cd boost
# git submodule update --init --recursive --remote --no-fetch --depth=1


export CFLAGS="-march=native -Ofast"
export CXXFLAGS="$CFLAGS"
./bootstrap.sh --with-python=`which python3`
./b2 -j`nproc` cflags="$CFLAGS" cxxflags="$CXXFLAGS"


echo "export BOOST_ROOT=`pwd`" >>~/.bashrc  # for cmake

echo "export CPATH=`pwd`:${CPATH}" >>~/.bashrc
echo "export LIBRARY_PATH=`pwd`/stage/lib:${LIBRARY_PATH}" >>~/.bashrc
