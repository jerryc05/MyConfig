0. `cd ~ && python3 -mvenv hass && python3 -mvenv hass`

0. `. ~/hass/bin/activate`

0. `pip install --pre -U homeassistant`

0. Install `ffmpeg`, `unzip`

0. Get `hacs` from https://github.com/hacs/get

0. Run as `hass --open-ui`

0. Add `hacs` as new integration

0. If running under WSL, allow inbound HASS Bridge (HomeKit) port.

0. If running under WSL, forward HASS Bridge (HomeKit) port, consider https://github.com/zmjack/PortProxyGUI.
