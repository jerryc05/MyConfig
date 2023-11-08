## Install `neovim`

## Install Astronvim
```sh
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak~
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

## Install Astronvim Community Packages
```sh
cat <<EOF >~/.config/nvim/lua/plugins/community.lua
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


mkdir -p ~/.config/nvim/lua/user/plugins/

cat <<EOF >~/.config/nvim/lua/user/plugins/todo-comments.lua
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    }
  }
}
EOF


cat <<EOF >~/.config/nvim/lua/user/plugins/clangd_extensions.lua
return {
  "clangd_extensions.nvim"
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
  { import = "clangd_extensions.nvim" },