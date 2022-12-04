#!/usr/bin/env sh

set -eou pipefail

. `dirname "$0"`/util.sh

tee_if_not_exists 'net.ipv4.tcp_keepalive_time = 1200' '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_fastopen = 3'          '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_tw_reuse = 1'          '/etc/sysctl.conf'

tee_if_not_exists '# 16384 = 16KiB'                    '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_notsent_lowat = 16384' '/etc/sysctl.conf'

tee_if_not_exists '# Increase to benefit from QUIC'    '/etc/sysctl.conf'
tee_if_not_exists 'net.core.rmem_max=2500000'          '/etc/sysctl.conf'

tee_if_not_exists '# Allow anyone to use [ping]'           '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.ping_group_range=0 2147483647' '/etc/sysctl.conf'

tee_if_not_exists '# Do not cache metrics on closing connections' '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_no_metrics_save = 1'              '/etc/sysctl.conf'

tee_if_not_exists '# Turn on window scaling which can enlarge the transfer window' '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_window_scaling = 1'                                '/etc/sysctl.conf'

tee_if_not_exists '# Enable select acknowledgments' '/etc/sysctl.conf'
tee_if_not_exists 'net.ipv4.tcp_sack = 1'           '/etc/sysctl.conf'



sudo sysctl -p
