#!/usr/bin/env sh

echo 'Update date: 2022-03-28'
set -eou pipefail

# Install `git`, `mercurial`, `cmake`, `libunwind`, `pcre`
sudo apt install git mercurial cmake libunwind-dev libpcre3-dev || \
sudo pacman -S   git mercurial cmake libunwind        pcre

BORINGSSL='boringssl'
BORINGSSL_DIR="`pwd`/$BORINGSSL"
(
  # Clone/update `BoringSSL`
  [ -f "$BORINGSSL_DIR" ] || git clone --depth=1 "https://github.com/google/$BORINGSSL.git $BORINGSSL_DIR"
  cd "$BORINGSSL_DIR"
  git fetch --depth=1
  git reset FETCH_HEAD

  # Build `BoringSSL`
  cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE='-DNDEBUG -Ofast -march=native -w' -DCMAKE_BUILD_TYPE=Release
  cmake --build build
)

NGX_BROTLI='ngx_brotli'
NGX_BROTLI_DIR="`pwd`/$NGX_BROTLI"
(
  # Clone/update `ngx_brotli`
  [ -f "$NGX_BROTLI_DIR" ] || git clone --depth=1 "https://github.com/google/$NGX_BROTLI.git $NGX_BROTLI_DIR"
  cd "$NGX_BROTLI_DIR"
  git fetch --depth=1
  git reset FETCH_HEAD
  git submodule update --init --depth=1
)

(
  REPO_NAME='nginx-quic'

  # Clone/update `nginx-quic`
  [ -f "$REPO_NAME" ] || hg clone -b quic "https://hg.nginx.org/$REPO_NAME"
  cd "$REPO_NAME"
  hg update

  # Build `nginx-quic`
  MODULE_PATH='/usr/lib/nginx/modules'
  ./auto/configure \
  --prefix='/etc/nginx' \
  --sbin-path='/usr/local/sbin/nginx' \
  --modules-path="$MODULE_PATH" \
  --conf-path='/etc/nginx/nginx.conf' \
  --with-cc-opt="-I$BORINGSSL_DIR/include -DNDEBUG -Ofast -march=native -w" \
  --with-ld-opt="-L$BORINGSSL_DIR/build/ssl -L$BORINGSSL_DIR/build/crypto" \
  --with-threads \
  --with-file-aio \
  --with-http_realip_module \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-http_gzip_static_module \
  --with-http_degradation_module \
  --without-http_auth_basic_module \
  --without-http_autoindex_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_ssl_preread_module \
  --with-stream_quic_module \
  --with-compat \
  --add-dynamic-module="$NGX_BROTLI_DIR"
  make
  make modules
  sudo make install
)
# --prefix=/usr/local/nginx \
# --sbin-path=[prefix]/sbin/nginx \
# --modules-path=[prefix]/modules \
# --conf-path=[prefix]/conf/nginx.conf \
# --user=nginx \
# --group=nginx \
# --with-http_addition_module \
# --with-http_xslt_module=dynamic \
# --with-http_image_filter_module=dynamic \
# --with-http_geoip_module=dynamic \
# --with-http_sub_module \
# --with-http_dav_module \
# --with-http_flv_module \
# --with-http_mp4_module \
# --with-http_gunzip_module \
# --with-http_auth_request_module \
# --with-http_random_index_module \
# --with-http_secure_link_module \
# --with-http_slice_module \
# --with-http_stub_status_module \
# --with-mail=dynamic \
# --with-mail_ssl_module \
# --with-stream_geoip_module=dynamic \
