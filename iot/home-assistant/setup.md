0. `cd ~ && python3 -mvenv hass && python3 -mvenv hass`

0. `. ~/hass/bin/activate`

0. `pip install --pre -U homeassistant`

0. Install `ffmpeg`, `unzip`

0. Get `hacs` from https://github.com/hacs/get

0. Run as `hass --open-ui`

0. Add `hacs` as new integration

0. If running under WSL, allow inbound HASS Bridge (HomeKit) TCP port in Windows Firewall, and forward HASS Bridge (HomeKit) port. See https://community.home-assistant.io/t/guide-hass-io-on-windows-10-wsl2-no-more-vms/166298
