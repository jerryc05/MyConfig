#!/usr/bin/env sh

set -eou pipefail

. `dirname "$0"`/../util.sh

tee_if_not_exists 'net.ipv4.tcp_keepalive_time = 1200' '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_fastopen = 3'          '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_tw_reuse = 1'          '/etc/sysctl.conf'
tee_if_not_exists '# 16384 = 16KiB'                    '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_notsent_lowat = 16384' '/etc/sysctl.conf'

sudo sysctl -p
