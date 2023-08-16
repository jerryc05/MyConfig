#!/usr/bin/env sh

set -eou pipefail

# Install `git`, `mercurial`, `cmake`, `libunwind`, `pcre`
sudo apt install git mercurial cmake libunwind-dev libpcre3-dev zlib1g-dev || \
sudo pacman -S   git mercurial cmake libunwind        pcre.     zlib

[ -z "$FLAGS" ] && echo "Run build_flags.sh first!" && exit 1

ZLIB_NG_DIR="$(pwd)/zlib-ng"
(
  # Clone/update `zlib-ng`
  [ -d "$ZLIB_NG_DIR" ] || git clone --depth=1 https://github.com/zlib-ng/zlib-ng.git "$ZLIB_NG_DIR"
  cd "$ZLIB_NG_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD

  # Build `zlib-ng`
  cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE="$FLAGS" -DCMAKE_BUILD_TYPE=Release -DZLIB_ENABLE_TESTS=OFF -DWITH_NATIVE_INSTRUCTIONS=ON
  cmake --build build --config=Release
)

# BORINGSSL_DIR="$(pwd)/boringssl"
# (
#   # Clone/update `BoringSSL`
#   [ -d "$BORINGSSL_DIR" ] || git clone --depth=1 https://github.com/google/boringssl.git "$BORINGSSL_DIR"
#   cd "$BORINGSSL_DIR"
#   git fetch --depth=1
#   git reset --hard origin/HEAD

#   # Build `BoringSSL`
#   cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE="$FLAGS" -DCMAKE_BUILD_TYPE=Release
#   cmake --build build
# )

QUICTLS_DIR="$(pwd)/quictls"
(
  # Clone/update `quictls`
  [ -d "$QUICTLS_DIR" ] || git clone --depth=1 https://github.com/quictls/openssl.git "$QUICTLS_DIR"
  cd "$QUICTLS_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD
  git submodule update --init --depth=1

  # Build `quictls`
  ./Configure \
  --release \
  --with-zlib-lib="$ZLIB_NG_DIR/build" \
  enable-ktls enable-ec_nistp_64_gcc_128 \
  no-ssl no-tls1-method no-tls1_1-method no-dtls1-method

  make
)

NGX_BROTLI_DIR="$(pwd)/ngx_brotli"
(
  # Clone/update `ngx_brotli`
  [ -d "$NGX_BROTLI_DIR" ] || git clone --depth=1 https://github.com/google/ngx_brotli.git "$NGX_BROTLI_DIR"
  cd "$NGX_BROTLI_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD
  git submodule update --init --depth=1
)

HEADERS_MORE_DIR="$(pwd)/headers-more"
(
  # Clone/update `ngx_brotli`
  [ -d "$HEADERS_MORE_DIR" ] || git clone --depth=1 https://github.com/openresty/headers-more-nginx-module.git "$HEADERS_MORE_DIR"
  cd "$HEADERS_MORE_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD
  git submodule update --init --depth=1
)

NGX_DEVEL_KIT_DIR="$(pwd)/ngx_devel_kit"
(
  [ -d "$NGX_DEVEL_KIT_DIR" ] || git clone --depth 1 https://github.com/vision5/ngx_devel_kit.git "$NGX_DEVEL_KIT_DIR"
  cd "$NGX_DEVEL_KIT_DIR"
  git fetch --depth=1
  git reset --hard origin/HEAD
)

SET_MISC_NGINX_MODULE="$(pwd)/set-misc-nginx-module"
(
  [ -d "$SET_MISC_NGINX_MODULE" ] || git clone --depth 1 https://github.com/openresty/set-misc-nginx-module.git "$SET_MISC_NGINX_MODULE"
  cd "$SET_MISC_NGINX_MODULE"
  git fetch --depth=1
  git reset --hard origin/HEAD
)


(
  REPO_NAME='nginx-quic'

  # Clone/update `nginx-quic`
  [ -d "$REPO_NAME" ] || hg clone -b default "https://hg.nginx.org/$REPO_NAME"
  cd "$REPO_NAME"
  hg update --clean -v

  # Test if `jemalloc` exists
  command -v jemalloc-config >/dev/null \
  && LINK_ARG="-L`jemalloc-config --libdir` -Wl,-rpath,`jemalloc-config --libdir` -ljemalloc `jemalloc-config --libs`" \
  || LINK_ARG=''

  # Decide which TLS library to use
  [ -d "$QUICTLS_DIR" ] && { TLS_LIB="$QUICTLS_DIR"; LINK_ARG="$LINK_ARG -Wl,-rpath,$QUICTLS_DIR"; } || TLS_LIB="$BORINGSSL_DIR"

  # *OPTIONAL* Remove error page body
  sed -i 's/ngx_stri.*),/ngx_null_string,/g' src/http/ngx_http_special_response.c

  # *OPTIONAL* Return 444 on error
  sed -i 's/= *\w\+BAD_REQUEST *;/=NGX_HTTP_CLOSE;/g' src/http/ngx_http_core_module.c

  # Build `nginx-quic`
  PREFIX_PATH="$(pwd)"  #'/etc/nginx'
  SBIN_PATH="$PREFIX_PATH/sbin/nginx"
  ./auto/configure \
  --prefix="$PREFIX_PATH" \
  --sbin-path="$SBIN_PATH" \
  --modules-path="$PREFIX_PATH/modules" \
  --conf-path="$PREFIX_PATH/nginx.conf" \
  --with-cc-opt="-I$TLS_LIB/include $LINK_ARG $FLAGS" \
  --with-ld-opt="-L$TLS_LIB -L$TLS_LIB/build/ssl -L$TLS_LIB/build/crypto $LINK_ARG" \
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
  --add-module="$NGX_BROTLI_DIR" \
  --add-module="$HEADERS_MORE_DIR" \
  --add-module="$NGX_DEVEL_KIT_DIR" \
  --add-module="$SET_MISC_NGINX_MODULE" 

  make
  make modules
  sudo make install

  # setcap
  sudo setcap CAP_NET_BIND_SERVICE=+eip "$SBIN_PATH"

  sudo tee /etc/systemd/system/nginx.service <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
#Type=forking  # If daemon_off, then Type=simple (default)
ExecStartPre="$SBIN_PATH" -t
ExecStart="$SBIN_PATH"
ExecReload="$SBIN_PATH" -s reload
ExecStop="$SBIN_PATH" -s stop
WorkingDirectory=$(pwd)
PrivateTmp=true

# Only enable when not running as root
User=$(whoami)
Group=$(whoami)
ProtectSystem=full

[Install]
WantedBy=multi-user.target
EOF
  systemd-analyze verify nginx.service
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
