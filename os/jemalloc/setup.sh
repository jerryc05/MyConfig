#!/usr/bin/env sh

set -eou pipefail

# Install `git`, `autoconf`
sudo apt install git autoconf || \
sudo pacman -S   git autoconf

[ -z "$FLAGS" ] && echo "Run [`git root`/os/build_flags.sh] first!" && exit 1
export EXTRA_CFLAGS="$FLAGS"
export EXTRA_CXXFLAGS="$EXTRA_CFLAGS"

JEMALLOC='jemalloc'
JEMALLOC_DIR="`pwd`/$JEMALLOC"
(
  # Clone/update `jemalloc`
  [ -d "$JEMALLOC_DIR" ] || git clone --depth=1 "https://github.com/$JEMALLOC/$JEMALLOC.git" "$JEMALLOC_DIR"
  cd "$JEMALLOC_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD

  # Build `jemalloc`
  ./autogen.sh \
  --disable-stats \
  --disable-prof-libgcc \
  --disable-prof-gcc \
  --disable-fill \
  --enable-lazy-lock

  make
  sudo make install
)
