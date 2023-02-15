## If DNS not working in Linux (especially after reboot/upgrade)
```sh
sudo nano /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
```