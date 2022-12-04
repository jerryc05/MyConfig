#!/usr/bin/env sh

set -eou pipefail

[ "$EUID" -ne 0 ] && echo 'ERR: root privilege needed!' && false

command -v git &>/dev/null && echo 'ERR: git not found!' && false

read -p 'Enter email address: ' EMAIL_ADDR

read -p 'Enter main domain (only one): '                      MAIN_DOMAIN
read -p 'Enter SAN domains, unquoted and separated by [-d]: ' SAN_DOMAINS
[ -n "$SAN_DOMAINS" ] && D_SAN_DOMAINS="-d $SAN_DOMAINS" || D_SAN_DOMAINS="$SAN_DOMAINS"

read -p 'Enter hook commands to be exec after renew (e.g. `systemctl restart nginx`): ' HOOK_CMD

[[ "$MAIN_DOMAIN" =~ ' ' ]] && echo 'ERR: main domain cannot contain SPACE!' && false

# Pre-install
KEY_LEN='ec-256'
ACME_HOME="$HOME/.acme.sh"

DEPLOY_PATH='/etc/acme.sh'
mkdir -p "$DEPLOY_PATH"
chmod -R 755 "$DEPLOY_PATH"

REPO_NAME='acme.sh'
(
  # Clone/update repo
  [ -d "$REPO_NAME" ] || git clone --depth=1 "https://github.com/acmesh-official/$REPO_NAME.git"
  cd "$REPO_NAME"
  git fetch --depth=1
  git reset --hard origin/HEAD

  # Fake install
  ln -s "`pwd`" "$ACME_HOME"
  [ `readlink -f "$ACME_HOME"` != "`pwd`" ] && echo "ERR: Fake install to [$ACME_HOME] failed\!" && false
)

(
  cd "$ACME_HOME"

  # Set default CA
  ./acme.sh --set-default-ca --server buypass

  # Register
  ./acme.sh --register-account -m "$EMAIL_ADDR"

  # Issue
  WWW_ROOT='/var/wwwroot'  # also change in [nginx.conf]
  mkdir -p "$WWW_ROOT"
  chmod -R 777 "$WWW_ROOT"
  chcon -Rt httpd_sys_content_t "$WWW_ROOT" || true
  ./acme.sh --issue --days 170 --keylength "$KEY_LEN" -d "$MAIN_DOMAIN" $D_SAN_DOMAINS -w "$WWW_ROOT"
  #                        └ buypass cert has 180 days

  # Install
  INSTALL_CMD=`
  echo \
  acme.sh --install-cert -d "$MAIN_DOMAIN" \
          --cert-file      "$DEPLOY_PATH/cert.pem" \
          --key-file       "$DEPLOY_PATH/key.pem" \
          --fullchain-file "$DEPLOY_PATH/fullchain.pem"
  `

  $INSTALL_CMD
  
  # Auto renew
  crontab <<< "0 0 * * * `pwd`/acme.sh --cron && { ${INSTALL_CMD:-true} ; } && ${HOOK_CMD:-true}"
)
