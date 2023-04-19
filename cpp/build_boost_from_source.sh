#!/usr/bin/env bash

set -euxo pipefail

build() {
    export CFLAGS="-w -march=native -Ofast -std=gnu++20"
    export CXXFLAGS="$CFLAGS"
    ./bootstrap.sh --with-python=`which python3` --with-icu #--without-libraries=mpi
    ./b2 -j`nproc` cflags="$CFLAGS" cxxflags="$CXXFLAGS"
}

mkdir boost && cd boost


###### THIS IS FOR NEW INSTALLATION ######
git clone --single-branch --branch master --depth=1 --recurse-submodules --shallow-submodules https://github.com/boostorg/boost.git ./
build
cat <<EOF >>~/.bashrc

# boost
export BOOST_ROOT=$(pwd)  # for cmake 
export CPATH=\$BOOST_ROOT:\$CPATH
export LIBRARY_PATH=\$BOOST_ROOT/stage/lib:\$LIBRARY_PATH

EOF

export __VERSION=$(grep 'Boost VERSION' CMakeLists.txt | grep -oE '[0-9.]+')
if command -v makepkg &>/dev/null; then
    export _TMPDIR=$(mktemp -d)
    cat <<EOF >"$_TMPDIR/PKGBUILD"
    pkgname='boost_dummy'
    pkgver=$__VERSION
    pkgrel=1
    arch=(any)
    provides=('boost=$__VERSION')
EOF
    (cd $_TMPDIR && makepkg -si)
fi


###### THIS IS FOR UPDATE ######
git submodule foreach | cut -d ' ' -f 2 | xargs -I@ -P `nproc` sh -c 'cd @ && git fetch --depth 1 && git reset --hard FETCH_HEAD'    
build
