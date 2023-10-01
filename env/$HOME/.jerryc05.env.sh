#!/usr/bin/env bash

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ]        && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"


# Cargo
[ -d "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"


# LLVM Clang for Mac
if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$(brew --prefix llvm)" ]; then
  export PATH="$(brew --prefix llvm)/bin:$PATH"
      __lib="-L$(brew --prefix llvm)/lib"     && { [[ ! "$LFDLAGS"  == *"$__lib"*     ]] && export  LDFLAGS="$LDFLAGS $__lib";      unset __lib;}
  __include="-I$(brew --prefix llvm)/include" && { [[ ! "$CPPFLAGS" == *"$__include"* ]] && export CPPFLAGS="$CPPFLAGS $__include"; unset __include;}
fi


# Arch's CUDA
if [ -d /opt/cuda ]; then
  export PATH=$PATH:/opt/cuda/bin
  export CPATH=/opt/cuda/include:$CPATH 
fi


# VSCode's LLVM tools
USR_DIRS=''
for D in "/c/Users/" "/mnt/c/Users/" "/home/"; do
  USR_DIRS="$USR_DIRS$(find "$D" -maxdepth 1 -type d 2>/dev/null)"
done
for USR in "$HOME" $USR_DIRS; do
  [ -d "$USR" ] || continue
  for VSC_DIR in '' '-insiders' '-server' '-server-insiders'; do
    EXT="$USR/.vscode$VSC_DIR/extensions/"
    [ -d "$EXT" ] || continue
    DIR="$(find "$EXT" -maxdepth 1 -type d -name "ms-vscode.cpptools-*")/LLVM/bin"
    [ -d "$DIR" ] && export PATH="$PATH:$DIR"
  done
done


# # gnu utils from brew
# PATH="$(fd -IL -t d gnubin "$(brew --prefix)/opt" | tr '\n' ':' ):$PATH"


# SSH Agent
DOT_SSH="$HOME/.ssh"
mkdir -p "$DOT_SSH"

# If using security key under WSL, with Putty in Windows
PIPERELAY="$DOT_SSH/npiperelay.exe"
if grep -qi "_NT" /proc/version &>/dev/null; then :;
elif command -v socat >/dev/null 2>&1 && grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null && [ -f "$PIPERELAY" ]; then
  # Download from [https://github.com/jstarks/npiperelay/releases]
  # Copy [npiperelay.exe] to ~/.ssh/
  # [chmod +x ~/.ssh/npiperelay.exe]

  export SSH_AUTH_SOCK="$DOT_SSH/agent.sock"
  WINDOWS_SSH_PIPE="//./pipe/openssh-ssh-agent"
  if ! ps -auxww | grep -q "[n]piperelay.exe -ei -s $WINDOWS_SSH_PIPE"; then
    [ -S "$SSH_AUTH_SOCK" ] && rm -f "$SSH_AUTH_SOCK"
    setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"$PIPERELAY -ei -s $WINDOWS_SSH_PIPE",nofork &>/dev/null &
  fi

else
  if command -v ssh-agent &>/dev/null && command -v ssh-add &>/dev/null; then
    ssh-add -l &>/dev/null
    if [ $? -eq 2 ]; then
      export SSH_AUTH_SOCK=$(cat "$DOT_SSH"/.SSH_AUTH_SOCK 2>/dev/null)
      export SSH_AGENT_PID=$(cat "$DOT_SSH"/.SSH_AGENT_PID 2>/dev/null)
      ssh-add -l &>/dev/null
      if [ $? -eq 2 ]; then
        eval "$(ssh-agent)" >/dev/null
        echo "$SSH_AUTH_SOCK" >"$DOT_SSH"/.SSH_AUTH_SOCK
        echo "$SSH_AGENT_PID" >"$DOT_SSH"/.SSH_AGENT_PID
      fi
    fi
  fi
fi


# XDG Variables
test "${XDG_CONFIG_HOME:="$HOME/.config"}"
test "${XDG_DATA_HOME:="$HOME/.local/share"}"


# Zsh tweaks
if [ -n "$ZSH_VERSION" ]; then
  # Fix button functionality for zsh
  command -v bindkey >/dev/null && {
    bindkey "^[[H"    beginning-of-line;
    bindkey "^[[F"    end-of-line;
    bindkey "^[[3~"   delete-char;
    bindkey "^[[1;5C" forward-word;
    bindkey "^[[1;5D" backward-word;
  }
  # Activate bash-like comment in interactive mode
  setopt interactivecomments
fi


# VSCode
command -v code          &>/dev/null && export VISUAL=code
command -v code-insiders &>/dev/null && export VISUAL=code-insiders
export MAKEFLAGS="-j$(nproc)"


## gnu utils from brew
#PATH="$(fd -IL -t d gnubin "$(brew --prefix)/opt" | tr '\n' ':' ):$PATH"


# CMake
export CMAKE_EXPORT_COMPILE_COMMANDS=ON
command -v ninja &>/dev/null && export CMAKE_GENERATOR=Ninja
#command -v ccache &>/dev/null && export CMAKE_CXX_COMPILER_LAUNCHER=ccache
command -v lld &>/dev/null && export CPPFLAGS="-fuse-ld=lld $CPPFLAGS"


# Collect flags
DEBUG_FLAGS="-g3 -ftrapv -D_FORTIFY_SOURCE=3 -D_GLIBCXX_ASSERTIONS=1 -D_GLIBCXX_DEBUG=1 -fstack-protector-strong -fstack-clash-protection -fcf-protection -Wl,-z,defs -Wl,-z,now -Wl,-z,relro"
RELEASE_FLAGS='-Ofast -march=native -fno-plt -fomit-frame-pointer'

CFLAGS="$CPPFLAGS"
CXXFLAGS="$CPPFLAGS"  # cmake won't pick up CPPFLAGS
LDFLAGS="-Wl,--sort-common,--as-needed $LDFLAGS"


## DEBUGINFOD_URLS
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org https://mirrors.cloud.tencent.com/archlinuxcn"


## WSL2 uses CFW
# export __HOSTIP=$(cat /etc/resolv.conf | grep -oP '(?<=nameserver\ ).*')
# if curl -v $__HOSTIP:7890 -m .05 &>/dev/null; then
#         export https_proxy=http://$__HOSTIP:7890
#         export http_proxy=http://$__HOSTIP:7890
#         export all_proxy=socks5://$__HOSTIP:7890
#         export ALL_PROXY=$all_proxy
# fi
