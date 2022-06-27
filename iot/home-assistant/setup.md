0. `cd ~ && python3 -mvenv hass && python3 -mvenv hass && . ~/hass/bin/activate`. Do not use `conda`

0. `pip install --pre -U homeassistant`

0. Install `ffmpeg`, `unzip`

0. Get `hacs` from https://github.com/hacs/get

0. Run as `hass --open-ui`

0. Add `hacs` as new integration

0. If running under WSL, allow inbound HASS Bridge (HomeKit) TCP port (check dashboard notification) and UDP port 5353 in Windows Firewall, and forward them. 
   - See https://community.home-assistant.io/t/guide-hass-io-on-windows-10-wsl2-no-more-vms/166298 and https://www.home-assistant.io/integrations/homekit/#firewall
   - Run in WSL
     ```
     export TCP_PORT=210??
     export WSL_IP=$(ip addr show eth0 | fgrep 'inet ' | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)

     (
     echo netsh advfirewall firewall add rule name="WSL - HASS HomeKit UDP Port" dir=in action=allow protocol=UDP localport=5353
     echo netsh advfirewall firewall add rule name="WSL - HASS HomeKit TCP Port" dir=in action=allow protocol=TCP localport=$TCP_PORT
     echo netsh interface portproxy add v4tov4 listenport=5353 listenaddress=0.0.0.0 connectport=5353 connectaddress=$WSL_IP
     echo netsh interface portproxy add v4tov4 listenport=$TCP_PORT listenaddress=0.0.0.0 connectport=$TCP_PORT connectaddress=$WSL_IP
     echo netsh interface portproxy show all)
     ```
