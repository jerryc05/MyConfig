#!/usr/bin/env sh

echo 'Update date: 2022-03-30'
set -eou pipefail

read -p "Enter email address: " YOUR_EMAIL_ADDR
read -p "Enter domain: " YOUR_DOMAIN

INSTALL_PATH='/etc/acme.sh'
KEY_LEN='ec-256'

# Pre-install
sudo mkdir -p -m755 "$INSTALL_PATH"

# Clone/update repo
(
  REPO_NAME='acme.sh'
  [ -d "$REPO_NAME" ] || git clone --depth=1 "https://github.com/acmesh-official/$REPO_NAME.git"
  cd "$REPO_NAME"
  git fetch --depth=1
  git reset --hard FETCH_HEAD
)

# Install
"$REPO_NAME/acme.sh" --install --cert-home "$INSTALL_PATH" --keylength "$KEY_LEN" -m "$YOUR_EMAIL_ADDR"

# Issue
WWW_ROOT='/var/wwwroot'  # also change in [nginx.conf]
sudo mkdir -p -m777 "$WWW_ROOT"
acme.sh --issue --cron --keylength "$KEY_LEN" -d "$YOUR_DOMAIN" -w "$WWW_ROOT"
