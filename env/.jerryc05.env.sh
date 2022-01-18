# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ]        && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Cargo
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

# LLVM Clang for Mac
if [ "$(uname -s)" = "Darwin" ] && [ -d "$(brew --prefix llvm)" ]; then
  export PATH="$(brew --prefix llvm)/bin:$PATH"
      __lib="-L$(brew --prefix llvm)/lib"     && { [[ ! "$LFDLAGS"  == *"$__lib"*     ]] && export  LDFLAGS="$LDFLAGS $__lib";      unset __lib }
  __include="-I$(brew --prefix llvm)/include" && { [[ ! "$CPPFLAGS" == *"$__include"* ]] && export CPPFLAGS="$CPPFLAGS $__include"; unset __include }
fi

# VSCode's LLVM tools
USER_DIRS=$'/root/\n'
for d in "/c/Users/" "/mnt/c/Users/" "/home/"; do
  USER_DIRS="$USER_DIRS`find $d -maxdepth 1 -type d 2>/dev/null`"
done
for USER in "$USER_DIRS"; do
  EXT="$USER/.vscode-insiders/extensions/"
  [ -d $EXT ] || continue
  DIR="`find $EXT -maxdepth 1 -type d -name "ms-vscode.cpptools-*"`/LLVM/bin"
  [ -d $DIR ] && export PATH="$PATH:$DIR"
done

# SSH Agent
if command -v ssh-agent >/dev/null 2>&1 && command -v ssh-add >/dev/null 2>&1; then
  ssh-add -l >/dev/null 2>&1
  if [ $? -eq 2 ]; then
    export DOT_SSH="$HOME/.ssh"
    mkdir -p $DOT_SSH

    export SSH_AUTH_SOCK=$(cat $DOT_SSH/.SSH_AUTH_SOCK 2>/dev/null)
    export SSH_AGENT_PID=$(cat $DOT_SSH/.SSH_AGENT_PID 2>/dev/null)

    ssh-add -l >/dev/null 2>&1
    if [ $? -eq 2 ]; then
      eval `ssh-agent`
      echo $SSH_AUTH_SOCK >$DOT_SSH/.SSH_AUTH_SOCK
      echo $SSH_AGENT_PID >$DOT_SSH/.SSH_AGENT_PID
    fi
  fi
fi
