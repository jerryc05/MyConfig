#!/usr/bin/env sh

git config --global user.name   'Jerry Chen'
git config --global user.email  'jerryc443@gmail.com'

# Must-haves
git config --global core.autocrlf     input
git config --global core.eol          lf
git config --global core.fileMode     true
git config --global core.longpaths    true
git config --global core.safecrlf     warn
git config --global core.fscache      true
git config --global help.autoCorrect  prompt

#git config --global core.sshcommand "C:/Windows/System32/OpenSSH/ssh.exe"
#  [core.sshcommand] will be overridden by [GIT_SSH_COMMAND] env var

# if { [ "$(uname)" = "Linux" ] && [ "$(git config --get credential.helper)" = '' ] ; }; then
#   git config --global credential.helper store
# fi

# Changes that might change behavior
git config --global push.autoSetupRemote  true
git config --global core.symlinks         true 
git config --global rebase.autoStash      true
git config --global merge.ff              false
git config --global merge.autoStash       true
git config --global --add --bool rebase.updateRefs true


git config --global rerere.enabled    true
#git config --global rerere.autoUpdate true


git config --global commit.gpgsign         true
git config --global tag.gpgsign            true
git config --global tag.forceSignAnnotated true
git config --global pull.rebase            true
git config --global fetch.prune            true

# Maybe unwanted
git config --global core.quotePath  false
git config --global core.ignorecase false

# If sign using ssh
git config --global gpg.format ssh
#git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'  # not working with security keys! use [signingkey] instead
git config --global user.signingkey $SSH_KEY_PATH
# If sign using pgp
#git config --global gpg.program "/path/to/gpg_executable"
git config --global user.signingkey $GPG_KEY_ID


git config --global alias.c 'commit'
git config --global alias.s 'status'
git config --global alias.ss 'git status --porcelain | cut -d ' ' -f 3 | xargs -I@ ls -hs @'
#                         └ [S]tatus [S]ize

git config --global alias.p   'push'
git config --global alias.pp  '!git pull && git push'
#git config --global alias.ppp 'pull'

git config --global alias.adog  'log --all --decorate --oneline --graph'
git config --global alias.ls    'ls-files -s'
git config --global alias.root  'rev-parse --show-toplevel'

git config --global alias.slf 'fetch --depth=1'
#                         └ [S]ha[l]low [F]etch
git config --global alias.hrr '!git reset `git remote | head -n 1`/HEAD --hard'
#                         └ [H]ard [R]eset to [R]emote branch
git config --global alias.fsz '!git rev-list --objects --all | git cat-file --batch-check="%(objecttype) %(objectname) %(objectsize) %(rest)" | sed -n "s/^blob //p" | sort -n --key=2'
#                         └ [F]ile [S]i[Z]e
git config --global alias.rh '!git rev-list HEAD | tail -n 1'
#                         └ [R]oot [H]ashgit config --global alias.rh '!git rev-list HEAD | tail -n 1'
git config --global alias.lit 'ls-files --cached -i --exclude-standard'
#                         └ [L]ist [I]gnored but [T]racked files



v_leq() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

if { [[ `uname` == "MINGW64_NT"* ]] || [[ `uname` == "Darwin"* ]] || ( [[ `uname` == "Linux" ]] && v_leq 2.37 $(git --version | cut -d ' ' -f 3) ); }; then
  git config --global core.fsmonitor  true
fi