#!/usr/bin/env bash
set -euxo pipefail

# make sure you have automake, autoconf, llvm, llvm-libs, clang, lld


build() {
    export CFLAGS="-w -march=native -Ofast"
    export CXXFLAGS="$CFLAGS -std=gnu++17"

    command -v llvm-config &>/dev/null || { echo 'llvm-config not found!' && exit 1; }
    export LLVM_CONFIG=$(which llvm-config)
    export BIN_PATH=$(dirname $LLVM_CONFIG)

    make clean
    make NO_NYX=1 -j$(nproc) source-only  #cc=

    cat <<EOF
===== You should see the following output some where in the middle: ====
Build Summary:
[+] afl-fuzz and supporting tools successfully built
[+] LLVM basic mode successfully built
[+] LLVM mode successfully built
[+] LLVM LTO mode successfully built
[+] gcc_mode successfully built
EOF

    mkdir -p bin && find . -maxdepth 1 -executable | xargs -I @ -P $(nproc) bash -c "{ file @ | grep -E 'executable|symbolic' &>/dev/null; } && cd bin &&  ln -sf {../,}@"


    export __VERSION=$(grep '#define VERSION' include/config.h | grep -oE '[0-9.]+\w*')
    if command -v makepkg &>/dev/null; then
        export _TMPDIR=$(mktemp -d)
        cat <<EOF >"$_TMPDIR/PKGBUILD"
pkgname='aflplusplus_dummy'
pkgver=$__VERSION
pkgrel=1
arch=(any)
provides=('aflplusplus=$__VERSION')
depends=(llvm which make clang llvm diffutils python)
optdepends=(openmp)
EOF
        (cd $_TMPDIR && makepkg -si)
    fi
}






mkdir AFLplusplus && cd AFLplusplus

###### THIS IS FOR NEW INSTALLATION ######
git clone --single-branch --depth=1 https://github.com/AFLplusplus/AFLplusplus.git .
build
  

cat <<EOF >>~/.bashrc

# afl++
export AFL_PATH=$(pwd)
export PATH=\$PATH:$(pwd)/bin

EOF


  



###### THIS IS FOR UPDATE ######
git fetch --depth 1 && git reset --hard FETCH_HEAD
build
