#!/usr/bin/env sh

# export HOMEBREW_INSTALL_FROM_API=1
# ^^^^^^ default since brew 4.0

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


brew doctor
