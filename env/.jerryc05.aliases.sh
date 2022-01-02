# Color! More color! But not all on MacOS!
[ "$(uname -s)" = "Linux" ] && alias dir='dir --color=auto'
[ "$(uname -s)" = "Linux" ] && alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# More on `ls`
[ "$(uname -s)" = "Linux" ] && ls_color='--color=auto' || ls_color='-G'
alias ls="ls $ls_color"
alias l ="ls $ls_color -F"
alias ll="ls $ls_color -alF"

alias cp="cp -i --sparse=auto --reflink=auto"
#            |  |             |
#            |  |             `----> Copy On Write
#            |  `------------------> Sparse Files
#            `---------------------> Prevent unintended file overwrite

# Show 256 colors
alias show-256-colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

# valgrind
alias vg="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"

# install rpm here
command -v rpm2cpio >/dev/null && rpmhere() { rpm2cpio $1 | cpio -iduv; }

# git-delta w/ exit code
# install git-delta via one of these:
#   1) brew install git-delta
#   2) cargo install --git https://github.com/dandavison/delta.git
command -v delta >/dev/null && xdelta() {
  out__=$(delta --width $(tput cols) -ns $*) && echo $out__ && [ -z $out__ ]
}

# Fix button functionality for zsh
command -v bindkey >/dev/null && {
  bindkey  "^[[H"   beginning-of-line;
  bindkey  "^[[F"   end-of-line;
  bindkey  "^[[3~"  delete-char;
}

# Show hidden files in iFinder
[ "$(uname -s)" = "Darwin" ] && defaults write com.apple.finder AppleShowAllFiles YES

# More helpful tar/untar
command -v tar >/dev/null && xtar() {
  echo "XZ_OPT=-8 tar acvf $* \n"
        XZ_OPT=-8 tar acvf $*
} && xuntar() {
  echo "tar xvf $* \n"
        tar xvf $*
}

# Hnady rsync command
# alias xrsync="rsync -ahLPvvz --delete-after --no-whole-file --info=progress2 --include='**.gitignore' --exclude='.git' --filter=':- .gitignore' "
alias xrsync="{ git ls-files||find . -print;}|rsync -ahLPvvz --delete-after --no-whole-file --info=progress2 --files-from=- "
#                    ||||| |
#                    ||||| `----> compress file data during the transfer
#                    ||||`------> increase verbosity
#                    |||`-------> keep partially transferred files + show progress during transfer
#                    ||`--------> transform symlink into referent file/dir
#                    |`---------> output numbers in a human-readable format
#                    `----------> archive mode; equals -rlptgoD (no -H,-A,-X) \
