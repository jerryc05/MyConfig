## If DNS not working in Linux (especially after reboot/upgrade)
```sh
sudo nano /etc/systemd/resolved.conf  # edit it there

sudo systemctl restart systemd-resolved
sudo mv /etc/resolv.conf{,.orig}
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```