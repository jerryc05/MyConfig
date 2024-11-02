#!/usr/bin/env bash

# Color! More color!
[ "$OSTYPE" = "linux-gnu" ] && alias dir='dir --color=auto'
[ "$OSTYPE" = "linux-gnu" ] && alias vdir='vdir --color=auto'
alias  grep='grep --color=auto'
alias fgrep='grep -F'
alias egrep='grep -E'

# More on [ls]
if [[ $(ls --version 2>&1) == *"GNU coreutil"* ]]; then
  ls_color='--color=auto'
  alias ls="ls $ls_color"
  alias  l="ls $ls_color -F"
  alias ll="ls $ls_color -alFHZ"
fi

alias cp='cp -i --sparse=always --reflink=auto'
#             |   |             └-> Copy On Write
#             |   └---------------> Sparse Files
#             └-------------------> Prevent unintended file overwrite

# Show 256 colors
alias show-256-colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

# valgrind
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

# install rpm here
command -v rpm2cpio >/dev/null && rpmhere() { rpm2cpio "$*" | cpio -iduv; }

# Show hidden files in iFinder
[[ "$OSTYPE" == "darwin"* ]] && defaults write com.apple.finder AppleShowAllFiles YES

# More helpful tar/untar
if command -v tar >/dev/null; then
  xtar() {
    str="XZ_OPT=-9 tar acf $*"
    echo -e "$str\n===================\n"
    eval "$str"
  }
  xuntar() {
    str="tar xf $*"
    echo -e "$str\n=======\n"
    eval "$str"
  }
fi

# VSCode, if only insiders is installed, alias to it
command -v code >/dev/null || { command -v code-insiders >/dev/null && alias code=code-insiders; }

# rm quarantine
[[ "$OSTYPE" == "darwin"* ]] && alias rmquarantine=sudo xattr -d com.apple.quarantine