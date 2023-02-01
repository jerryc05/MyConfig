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
command -v rpm2cpio >/dev/null && rpmhere() { rpm2cpio $* | cpio -iduv; }

# Show hidden files in iFinder
[[ "$OSTYPE" == "darwin"* ]] && defaults write com.apple.finder AppleShowAllFiles YES

# More helpful tar/untar (DO NOT QUOTE $*)
if command -v tar >/dev/null; then
  xtar() {
    str="XZ_OPT=-9 tar acvf $*"
    echo "$str\n===================\n"
    eval "$str"
  }
  xuntar() {
    str="tar xvf $*"
    echo "$str\n=======\n"
    eval "$str"
  }
fi

# Handy rsync command
xrsync() {
  if [ "$OSTYPE" = "linux-gnu" ] || [ "$OSTYPE" = "cygwin" ] ; then PREALLOCATE_ARG='--preallocate'; else PREALLOCATE_ARG=''; fi
  rsync -ahPvvz --relative --safe-links --perms $PREALLOCATE_ARG --sparse --delete-during --no-whole-file --skip-compress='jpg/jpeg/png/mp[34]/avi/mkv/xz/zip/gz/7z/bz2' --info=progress2 $*; }
  #      |||| └-> compress file data during the transfer
  #      |||└---> increase verbosity
  #      ||└----> keep partially transferred files + show progress during transfer
  #      |└-----> output numbers in a human-readable format
  #      └------> archive mode; equals -rlptgoD (no -H,-A,-X)
drsync(){ if command -v git >/dev/null; then xrsync --exclude='.git/' --exclude="$(git -C "$1" ls-files --exclude-standard -oi --directory)" $*; else xrsync $*; fi;}

# VSCode, if only insiders is installed, alias to it
command -v code >/dev/null || { command -v code-insiders >/dev/null && alias code=code-insiders; }
