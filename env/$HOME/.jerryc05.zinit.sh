#!/usr/bin/env zsh

# Plugins
zinit ice depth=1;zinit light zsh-users/zsh-autosuggestions && export ZSH_AUTOSUGGEST_USE_ASYNC=1
#zinit ice depth=1;zinit light zsh-users/zsh-completions
zinit ice depth=1;zinit light marlonrichert/zsh-autocomplete #\
#&& zstyle ':completion:*' substitute no && zstyle ':completion:*:*:man:*:*' menu select=long search
#   |                                       └ https://github.com/marlonrichert/zsh-autocomplete/issues/388#issuecomment-1010988568
#   └ https://github.com/marlonrichert/zsh-autocomplete/issues/374
zinit ice depth=1;zinit light agkozak/zsh-z
zinit ice depth=1;zinit light supercrabtree/k && { command -v numfmt >/dev/null || { command -v brew >/dev/null && brew install coreutils; }; }

# Syntax highlighting light (MUST BE THE LAST BUNBDLE)
zinit ice depth=1;zinit light zdharma-continuum/fast-syntax-highlighting

# Load the theme
zinit ice depth=1;zinit light romkatv/powerlevel10k
