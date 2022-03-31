#!/usr/bin/env sh

echo 'Update date: 2022-03-31'
set -eou pipefail

# Install `git`, `autoconf`
sudo apt install git autoconf || \
sudo pacman -S   git autoconf

MAKEFLAGS="$MAKEFLAGS -j $(($(nproc) * 2))"

JEMALLOC='jemalloc'
JEMALLOC_DIR="`pwd`/$JEMALLOC"
(
  # Clone/update `jemalloc`
  [ -d "$JEMALLOC_DIR" ] || git clone --depth=1 "https://github.com/$JEMALLOC/$JEMALLOC.git" "$JEMALLOC_DIR"
  cd "$JEMALLOC_DIR"
  git fetch --depth=1
  git reset --hard FETCH_HEAD

  # Build `jemalloc`
  export EXTRA_CFLAGS="-DNDEBUG -Ofast -march=native -w"
  export EXTRA_CXXFLAGS="$EXTRA_CFLAGS"
  ./autogen.sh \
  --disable-stats \
  --disable-prof-libgcc \
  --disable-prof-gcc \
  --disable-fill \
  --enable-lazy-lock

  make
  sudo make install
)
