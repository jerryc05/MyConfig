#!/usr/bin/env sh

set -eou pipefail

. `dirname "$0"`/util.sh

sudo modprobe tcp_bbr
tee_if_not_exists 'tcp_bbr' '/etc/modules-load.d/bbr.conf'
lsmod | grep -F bbr
sysctl net.ipv4.tcp_available_congestion_control | grep -F bbr

tee_if_not_exists 'net.ipv4.tcp_congestion_control = bbr' '/etc/sysctl.conf'
tee_if_not_exists '# BBR must be used with fq qdisc'      '/etc/sysctl.conf'
tee_if_not_exists 'net.core.default_qdisc = fq'           '/etc/sysctl.conf'
sudo sysctl -p
sysctl net.ipv4.tcp_congestion_control | grep -F bbr
