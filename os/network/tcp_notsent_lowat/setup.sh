#!/usr/bin/env sh

echo 'Update date: 2022-04-01'
set -eou pipefail

echo 'net.ipv4.tcp_notsent_lowat = 16384  # 16KiB' | sudo tee -a /etc/sysctl.conf
