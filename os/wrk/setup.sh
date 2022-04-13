#!/usr/bin/env sh

set -eou pipefail

# Install `git`, `luajit`, `unzip`
sudo apt install git luajit unzip || \
sudo pacman -S   git luajit unzip

[ -z "$FLAGS" ] && echo "Run [`git root`/os/build_flags.sh] first!" && exit 1

OPENSSL_DIR="`pwd`/openssl"
(
  # Clone/update
  [ -d "$OPENSSL_DIR" ] || git clone --depth=1 https://github.com/openssl/openssl.git "$OPENSSL_DIR"
  cd "$OPENSSL_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD
)

WRK_DIR="`pwd`/wrk"
(
  # Clone/update
  [ -d "$WRK_DIR" ] || git clone --depth=1 https://github.com/wg/wrk.git "$WRK_DIR"
  cd "$WRK_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD

  # Build
  make WITH_OPENSSL="$OPENSSL_DIR"  # WITH_LUAJIT=/usr
  sudo ln -s "`pwd`/wrk" /usr/local/bin/wrk
)
