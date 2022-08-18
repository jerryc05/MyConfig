#!/usr/bin/env sh

git config --global user.name   'Ziyan "Jerry" Chen'
git config --global user.email  'jerryc443@gmail.com'


git config --global core.autocrlf   input
git config --global core.eol        lf
git config --global core.fileMode   true
git config --global core.fsmonitor  true
git config --global core.longpaths  true
git config --global core.safecrlf   warn
git config --global core.fscache    true
#git config --global core.sshcommand "C:/Windows/System32/OpenSSH/ssh.exe"
#  [core.sshcommand] will be overridden by [GIT_SSH_COMMAND] env var


git config --global core.symlinks            true
git config --global help.autoCorrect         prompt
git config --global pull.rebase              false
git config --global rebase.autoStash         true
git config --global merge.autoStash          true


git config --global rerere.enabled    true
#git config --global rerere.autoUpdate true


git config --global commit.gpgsign         true
git config --global tag.gpgsign            true
git config --global tag.forceSignAnnotated true
# If sign using ssh
git config --global gpg.format ssh
#git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'  # not working with sec keys! use [signingkey] instead
# If sign using pgp
#git config --global gpg.program "/path/to/gpg_executable"
git config --global user.signingkey $HOME/.ssh/id_ed25519.pub  # or GPG_KEY_ID or SSH_PUBKEY_PATH


git config --global alias.c 'commit'
git config --global alias.s 'status'

git config --global alias.p   'push'
git config --global alias.pp  '!git pull && git push'
git config --global alias.ppp 'pull'

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
#                         └ [R]oot [H]ash
