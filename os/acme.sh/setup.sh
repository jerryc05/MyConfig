#!/usr/bin/env sh

set -eou pipefail

[ "$EUID" -ne 0 ] && echo "Please run as root" && exit

read -p 'Enter email address: '                        YOUR_EMAIL_ADDR
read -p 'Enter domain, unquoted and separated by [-d]: ' YOUR_DOMAIN

# Install `git`
sudo apt install git || \
sudo pacman -S   git

# Pre-install
KEY_LEN='ec-256'
DEPLOY_PATH='/etc/acme.sh' 
sudo mkdir -p "$DEPLOY_PATH"
sudo chmod -R 766 "$DEPLOY_PATH"

REPO_NAME='acme.sh'
(
  # Clone/update repo
  [ -d "$REPO_NAME" ] || git clone --depth=1 "https://github.com/acmesh-official/$REPO_NAME.git"
  cd "$REPO_NAME"
  git fetch --depth=1
  git reset --hard origin/HEAD

  # Install
  ./acme.sh --install --cert-home "$DEPLOY_PATH" --keylength "$KEY_LEN" -m "$YOUR_EMAIL_ADDR"
)

# Reload shell
. "$HOME/.`echo $0 | sed 's/^-//'`rc"

# Issue
WWW_ROOT='/var/wwwroot'  # also change in [nginx.conf]
sudo mkdir -p "$WWW_ROOT"
sudo chmod -R 777 "$WWW_ROOT"
acme.sh --issue --keylength "$KEY_LEN" -d $YOUR_DOMAIN -w "$WWW_ROOT"

# Deploy
chmod -R +r "$INSTALL_PATH"
find "$INSTALL_PATH" -type d | xargs chmod +x
sudo mv "$INSTALL_PATH/acme.sh" "$DEPLOY_PATH"
