## HASS Setup Guide + Patch for Windows
set -euo pipefail


## Make sure you are in a [venv]. [conda] does not seem to work.
[ -z "${VIRTUAL_ENV}" ] && echo "Not in a python [venv]" && exit 1
echo "python: $(which python)"
echo "pip   : $(which pip)"
read -p 'Looking good?' -n 1 -r


## If running under Windows
if [[ "$(uname -a)" = *"MINGW64_NT"* ]]; then
   ## Make sure you have MS C++ 14.0+ Build Tools
   ## Make sure you have Win 10+ SDK
   ## Make sure you have WinPcap/Npcap (https://npcap.com/#download)
fi


## Make sure these commands are ready
command -v ffmpeg
command -v unzip


## Install
pip install -U --pre wheel homeassistant sqlalchemy fnvhash tzdata


## Patch
if [[ "$(uname -a)" = *"MINGW64_NT"* ]]; then
   ## Patch 1 - lib/site-packages/homeassistant/util/file.py
   ## Replace
   'os.fchmod(fdesc.fileno(), 0o644)'
   'os.fchmod(fdesc.fileno(), 0o644) if os.name != "nt" else os.chmod(fdesc.name, 0o644)'

   ## Patch 2 - lib/site-packages/homeassistant/runner.py
   ## Replace
   'return await hass.async_run()'
   'import os;return await hass.async_run(attach_signals=os.name != "nt")'

   ## Patch 2 - lib/site-packages/homeassistant/components/onboarding/views.py
   ## Replace
   'onboard_integrations = ["met", "radio_browser"]'
   'import os;onboard_integrations = ["met","radio_browser"] if os.name!="nt" else ["met"]'
   ## Explain: [aiodns], a dependency of [radio_browser], is currently not compatible with Windows, see https://github.com/saghul/aiodns/issues/86
fi


## Recommended: Get [HACS] from [https://github.com/hacs/get]

## Run
hass --ignore-os-check --open-ui

## Add `hacs` as new integration
