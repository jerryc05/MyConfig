#!/usr/bin/env bash

# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-postfix-e-mail-server-with-dovecot

set -euxo pipefail

sudo apt install postfix
sudo postfix stop

