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

  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.cpp" },
  --{ import = "astrocommunity.pack.cmake" },
  --{ import = "astrocommunity.pack.typescript" },
  --{ import = "astrocommunity.pack.java" },
  --{ import = "astrocommunity.pack.rust" },
}
EOF
```

## Update
Inside nvim, run:
```
:Lazy check
:Lazy update
:AstroUpdate
:AstroUpdatePackages
```