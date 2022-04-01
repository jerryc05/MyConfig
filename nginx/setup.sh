#!/usr/bin/env sh

echo 'Update date: 2022-03-30'
set -eou pipefail

# Install `git`, `mercurial`, `cmake`, `libunwind`, `pcre`
sudo apt install git mercurial cmake libunwind-dev libpcre3-dev || \
sudo pacman -S   git mercurial cmake libunwind        pcre

MAKEFLAGS="$MAKEFLAGS -j $(($(nproc) * 2))"
FLAGS='-DNDEBUG -Ofast -march=native -Werror=vla-parameter -w'
export CFLAGS="$CFLAGS $FLAGS"
export CXXFLAGS="$CXXFLAGS $FLAGS"

ZLIB_NG_DIR="`pwd`/zlib-ng"
(
  # Clone/update `zlib-ng`
  [ -d "$ZLIB_NG_DIR" ] || git clone --depth=1 https://github.com/zlib-ng/zlib-ng.git "$ZLIB_NG_DIR"
  cd "$ZLIB_NG_DIR"
  git fetch --depth=1
  git reset --hard FETCH_HEAD

  # Build `zlib-ng`
  cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE="$FLAGS" -DCMAKE_BUILD_TYPE=Release -DZLIB_ENABLE_TESTS=OFF -DWITH_NATIVE_INSTRUCTIONS=ON
  cmake --build build --config=Release
)

# BORINGSSL_DIR="`pwd`/boringssl"
# (
#   # Clone/update `BoringSSL`
#   [ -d "$BORINGSSL_DIR" ] || git clone --depth=1 https://github.com/google/boringssl.git "$BORINGSSL_DIR"
#   cd "$BORINGSSL_DIR"
#   git fetch --depth=1
#   git reset --hard FETCH_HEAD

#   # Build `BoringSSL`
#   cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE="$FLAGS" -DCMAKE_BUILD_TYPE=Release
#   cmake --build build
# )

QUICTLS_DIR="`pwd`/quictls"
(
  # Clone/update `quictls`
  [ -d "$QUICTLS_DIR" ] || git clone --depth=1 https://github.com/quictls/openssl.git "$QUICTLS_DIR"
  cd "$QUICTLS_DIR"
  git fetch --depth=1
  git reset --hard FETCH_HEAD
  git submodule update --init --depth=1

  # Build `quictls`
  ./Configure \
  --release \
  --with-zlib-lib="$ZLIB_NG_DIR/build" \
  enable-ktls enable-ec_nistp_64_gcc_128 \
  no-ssl no-tls1-method no-tls1_1-method no-dtls1-method

  make
)

NGX_BROTLI_DIR="`pwd`/ngx_brotli"
(
  # Clone/update `ngx_brotli`
  [ -d "$NGX_BROTLI_DIR" ] || git clone --depth=1 https://github.com/google/ngx_brotli.git "$NGX_BROTLI_DIR"
  cd "$NGX_BROTLI_DIR"
  git fetch --depth=1
  git reset --hard FETCH_HEAD
  git submodule update --init --depth=1
)

HEADERS_MORE_DIR="`pwd`/headers-more"
(
  # Clone/update `ngx_brotli`
  [ -d "$HEADERS_MORE_DIR" ] || git clone --depth=1 https://github.com/openresty/headers-more-nginx-module.git "$HEADERS_MORE_DIR"
  cd "$HEADERS_MORE_DIR"
  git fetch --depth=1
  git reset --hard FETCH_HEAD
  git submodule update --init --depth=1
)

(
  REPO_NAME='nginx-quic'

  # Clone/update `nginx-quic`
  [ -d "$REPO_NAME" ] || hg clone -b quic "https://hg.nginx.org/$REPO_NAME"
  cd "$REPO_NAME"
  hg update

  # Test if `jemalloc` exists
  command -v jemalloc-config >/dev/null \
  && LINK_ARG="-L`jemalloc-config --libdir` -Wl,-rpath,`jemalloc-config --libdir` -ljemalloc `jemalloc-config --libs`" \
  || LINK_ARG=''

  # Decide which TLS library to use
  [ -d "$QUICTLS_DIR" ] && { TLS_LIB="$QUICTLS_DIR"; LINK_ARG="$LINK_ARG -Wl,-rpath,$QUICTLS_DIR"; } || TLS_LIB="$BORINGSSL_DIR"

  # Build `nginx-quic`
  PREFIX_PATH='/etc/nginx'
  MODULE_PATH="$PREFIX_PATH/modules"
  ./auto/configure \
  --prefix="$PREFIX_PATH" \
  --sbin-path='/usr/local/sbin/nginx' \
  --modules-path="$MODULE_PATH" \
  --conf-path='/etc/nginx/nginx.conf' \
  --with-cc-opt="-I$TLS_LIB/include $FLAGS" \
  --with-ld-opt="-L$TLS_LIB -L$TLS_LIB/build/ssl -L$TLS_LIB/build/crypto $LINK_ARG" \
  --with-threads \
  --with-file-aio \
  --with-http_realip_module \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-http_gzip_static_module \
  --with-http_degradation_module \
  --without-http_gzip_module \
  --without-http_auth_basic_module \
  --without-http_autoindex_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_ssl_preread_module \
  --with-stream_quic_module \
  --with-compat \
  --add-dynamic-module="$NGX_BROTLI_DIR" \
  --add-dynamic-module="$HEADERS_MORE_DIR"

  make
  make modules
  sudo make install
)
# [http_gzip_module] uses regular zlib, it's slow, don't

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
