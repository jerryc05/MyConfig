#!/usr/bin/env sh

export HOMEBREW_INSTALL_FROM_API=1

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor
