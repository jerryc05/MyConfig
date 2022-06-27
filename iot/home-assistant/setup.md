0. `pip install -U homeassistant`

0. Install `ffmpeg`

0. If using Windows, install `npcap`

0. If using Windows, open `helpers/signal.py`, make `async_register_signal_handling()` function do nothing by adding `return` to its first line

0. If using Windows, open `util/file.py` and catch any exception caused by `os.fchmod()`

0. Run as `hass --ignore-os-check --open-ui`