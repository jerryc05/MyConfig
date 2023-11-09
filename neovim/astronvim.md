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
  --{ import = "astrocommunity.pack.typescript" },
  --{ import = "astrocommunity.pack.java" },
  --{ import = "astrocommunity.pack.rust" },
}
EOF

cat <<EOF >$NVIM_CONFIG/lua/user/options.lua
return {
  opt = {
    relativenumber = false,
    number = true,
  }
}
EOF


mkdir -p $NVIM_CONFIG/lua/user/plugins/

cat <<EOF >$NVIM_CONFIG/lua/user/plugins/init.lua
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    event = "User AstroFile",
  },
  {
    "dnlhc/glance.nvim",
    opts = {},
    event = "User AstroLspSetup",
  },
  {
    "rmagatti/goto-preview",
    opts = {},
    event = "User AstroLspSetup",
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