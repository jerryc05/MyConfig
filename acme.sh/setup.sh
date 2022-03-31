#!/usr/bin/env sh

echo 'Update date: 2022-03-30'
set -eou pipefail

read -p 'Enter email address: ' YOUR_EMAIL_ADDR
read -p 'Enter domain, separated by " -d ": ' YOUR_DOMAIN

DEPLOY_PATH='/etc/acme.sh'
INSTALL_PATH="${XDG_CONFIG_HOME:="$HOME/.config"}/acme.sh"
KEY_LEN='ec-256'

# Pre-install
sudo mkdir -p "$DEPLOY_PATH"
sudo chmod -R 755 "$DEPLOY_PATH"
mkdir -p "$INSTALL_PATH"

REPO_NAME='acme.sh'
(
  # Clone/update repo
  [ -d "$REPO_NAME" ] || git clone --depth=1 "https://github.com/acmesh-official/$REPO_NAME.git"
  cd "$REPO_NAME"
  git fetch --depth=1
  git reset --hard FETCH_HEAD

  # Install
  ./acme.sh --install --cert-home "$INSTALL_PATH" --keylength "$KEY_LEN" -m "$YOUR_EMAIL_ADDR"
)

# Reload shell
. "$HOME/.`echo $0 | sed 's/^-//'`rc"

# Issue
WWW_ROOT='/var/wwwroot'  # also change in [nginx.conf]
sudo mkdir -p "$WWW_ROOT"
sudo chmod -R 777 "$WWW_ROOT"
acme.sh --issue --keylength $KEY_LEN -d $YOUR_DOMAIN -w "$WWW_ROOT"

# Deploy
chmod -R +r "$INSTALL_PATH"
find "$INSTALL_PATH" -type d | xargs chmod +x
sudo mv "$INSTALL_PATH" "$DEPLOY_PATH"
