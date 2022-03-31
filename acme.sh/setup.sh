#!/usr/bin/env sh

echo 'Update date: 2022-03-30'
set -eou pipefail

INSTALL_PATH='/etc/acme.sh'
KEY_LEN='ec-256'

# Pre-install
sudo mkdir -p  "$INSTALL_PATH"
sudo chmod 755 "$INSTALL_PATH"

# Clone/update repo
(
  REPO_NAME='acme.sh'
  [ -f "$REPO_NAME" ] || git clone --depth=1 "https://github.com/acmesh-official/$REPO_NAME.git"
  cd "$REPO_NAME"
  git fetch --depth=1
  git reset --hard FETCH_HEAD
)

# Install
./acme.sh --install --cert-home "$INSTALL_PATH" --keylength "$KEY_LEN"  # -m YOUR_EMAIL_ADDR

# Issue
acme.sh --issue --cron --keylength "$KEY_LEN"  # -d YOUR_DOMAIN -w /home/wwwroot/YOUR_DOMAIN
