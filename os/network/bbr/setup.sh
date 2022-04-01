#!/usr/bin/env sh

echo 'Update date: 2022-04-01'
set -eou pipefail

sudo modprobe tcp_bbr
echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/bbr.conf
lsmod | fgrep bbr
sysctl net.ipv4.tcp_available_congestion_control | fgrep bbr

echo 'net.ipv4.tcp_congestion_control = bbr' | sudo tee -a /etc/sysctl.conf
echo 'net.core.default_qdisc          = fq  # BBR must be used with fq qdisc' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sysctl net.ipv4.tcp_congestion_control | fgrep bbr
