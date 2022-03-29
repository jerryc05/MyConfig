#!/usr/bin/env sh

echo 'Update date: 2022-03-28'
set -eou pipefail

# Install `git`, `mercurial`, `cmake`, `libunwind`, `pcre`
sudo apt install git mercurial cmake libunwind-dev libpcre3-dev || \
sudo pacman -S   git mercurial cmake libunwind        pcre

# Clone and update `BoringSSL` if already cloned before
(
  [ -f boringssl ] || git clone https://github.com/google/boringssl.git --depth=1
  cd boringssl
  git fetch --depth=1
  git reset FETCH_HEAD
)

# Build `BoringSSL`
(
  cd boringssl
  cmake -S. -Bbuild -DCMAKE_CXX_FLAGS_RELEASE='-DNDEBUG -Ofast -march=native -w' -DCMAKE_BUILD_TYPE=Release
  cmake --build build
)

# Clone and update `nginx-quic` if already cloned before
(
  [ -f nginx-quic ] || hg clone -b quic https://hg.nginx.org/nginx-quic
  cd nginx-quic
  hg update
)

# Build `nginx-quic`
(
cd nginx-quic
./auto/configure \
--prefix=/etc/nginx \
--sbin-path=/usr/local/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--with-cc-opt='-I../boringssl/include -DNDEBUG -Ofast -march=native -w' \
--with-ld-opt='-L../boringssl/build/ssl -L../boringssl/build/crypto' \
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
--with-compat
make
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
