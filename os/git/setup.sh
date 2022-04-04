#!/usr/bin/env sh

git config --global user.name   'Ziyan "Jerry" Chen'
git config --global user.email  'jerryc443@gmail.com'
git config --get-regexp 'user.*'

git config --global core.autocrlf   input
git config --global core.eol        lf
git config --global core.fileMode   true
git config --global core.safecrlf   warn
git config --global core.longpaths  true
#git config --global core.sshcommand "C:/Windows/System32/OpenSSH/ssh.exe"
#  [core.sshcommand] will be overridden by [GIT_SSH_COMMAND] env var
git config --get-regexp 'core.*'

git config --global rerere.enabled    true
#git config --global rerere.autoUpdate true
git config --get-regexp 'rerere.*'

git config --global commit.gpgsign         true
git config --global tag.gpgsign            true
git config --global tag.forceSignAnnotated true
# If sign using ssh
git config --global gpg.format ssh
git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
# If sign using pgp
#git config --global gpg.program "/path/to/gpg_executable"
#git config --global user.signingkey GPG_KEY_ID_OR_SSH_PUBKEY_HERE

git config --global init.defaultBranch       main
git config --global push.recursesubmodules   check
git config --global core.usebuiltinfsmonitor true
git config --global core.symlinks            true

git config --global pull.rebase      true
git config --global rebase.autoStash true
git config --global help.autoCorrect prompt

git config --global alias.c 'commit'
git config --global alias.p '!git pull && git push'
git config --global alias.s 'status'

git config --global alias.adog  'log --all --decorate --oneline --graph'
git config --global alias.ls    'ls-files -s'

git config --global alias.slf 'fetch --depth=1'
#                         └ [S]ha[l]low [F]etch
git config --global alias.hrr '!git reset `git remote | head -n 1`/HEAD --hard'
#                         └ [H]ard [R]eset to [R]emote branch
