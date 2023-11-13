## Install `neovim` and Set Config Path
```sh
export NVIM_CONFIG=~/.config/nvim/
[[ "$(uname)" = *NT* ]] && export NVIM_CONFIG=~/AppData/Local/nvim/
```

## Install Astronvim
```sh
[ -d $NVIM_CONFIG ] && mv $NVIM_CONFIG ~/.config/nvim.bak~
git clone --depth 1 https://github.com/AstroNvim/AstroNvim $NVIM_CONFIG
```

## Install Astronvim Community Packages
```sh
cat <<EOF >$NVIM_CONFIG/lua/plugins/community.lua
return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",

  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  -- { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.cpp" },
  --{ import = "astrocommunity.pack.cmake" },
  --{ import = "astrocommunity.pack.docker" },
  --{ import = "astrocommunity.pack.typescript" },
  --{ import = "astrocommunity.pack.java" },
  --{ import = "astrocommunity.pack.rust" },
}
EOF

cat <<EOF >$NVIM_CONFIG/lua/user/init.lua
return {
  options = {
    g = {
      icons_enabled = false,
    },
    opt = {
      number = true,
      relativenumber = false,
    },
  },
}
EOF


mkdir -p $NVIM_CONFIG/lua/user/plugins/

cat <<EOF >$NVIM_CONFIG/lua/user/plugins/init.lua
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "User AstroFile",
  },
  {
    -- Bracket Colorizer
    "hiphish/rainbow-delimiters.nvim",
    opts = {},
    event = "User AstroFile",
  },
  {
    -- Remember last open state
    "ethanholz/nvim-lastplace",
    opts = {},
    event = "User AstroFile",
  },
  {
    "ray-x/lsp_signature.nvim",
    opts = {},
    -- config = function(_, opts) require'lsp_signature'.setup(opts) end
    event = "VeryLazy",
  },
  "clangd_extensions.nvim",
}
EOF
```

## Setup Copilot
Inside nvim, run:
```
:Copilot auth
```

## Update
Inside nvim, run:
```
:Lazy check
:Lazy update
:AstroUpdate
:AstroUpdatePackages
```