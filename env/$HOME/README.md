# MyTemplate - Environment Settings

This is a personal environment configuration for development.

Use at your **OWN** risk.

## Table of Contents

0. [Terminal](#terminal)
    - [Commonly used scripts](#commonly-used-scripts)
    - [Still Bash? No! Try Zsh! (Unix-like)](#still-bash-no-try-zsh-unix-like)
        - [Set as default shell](#set-as-default-shell)
        - [Configure plugins](#configure-plugins)
        - [Summary](#summary)

## Terminal

### Commonly used scripts

- Aliases: [`.jerryc05.aliases.sh`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.jerryc05.aliases.sh)
- Environment Variables: [`.jerryc05.env.sh`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.jerryc05.env.sh)

### Still Bash? No! Try Zsh! (Unix-like)

#### Set as default shell

0. What shell am I using? Run `echo $0`
0. If you are already running `zsh`, skip this section.
0. Install `zsh` by yourself.
    - Linux (`apt`): `apt install zsh`
    - Linux (`pacman`): `pacman -S zsh`
    - MacOS (`brew`): `brew install zsh`
0. Set `zsh` as default:
    - If you are using MacOS, run this first: `echo $(which zsh) | sudo tee -a /etc/shells`
    - Run `chsh -s $(which zsh)` (you might want to `cat /etc/shells`)
0. **[OPTIONAL]** Now, you might want to copy (or link) your previous settings to `zsh`.
    0. `~/.zshenv` contains environment variables.
    0. `~/.zshrc` contains aliases, functions, and key bindings.
    0. Ask for help if you are confused.
0. Restart your terminal.
0. You will be prompted with `zsh`'s first-use wizard.
    - Enter `0` if it asks whether to create files like `.zshrc`

#### Configure plugins

##### Plugin manager: [`zinit`](https://github.com/zdharma-continuum/zinit)

- Installation:
  ```sh
  curl -fsSL https://git.io/zinit-install -o /tmp/zinit.sh &&\
  . /tmp/zinit.sh
  ```

- Configuration
  - Your `~/.jerryc05.zinit.sh` file should be very similar to [`.jerryc05.zinit.sh` in the repo](https://github.com/jerryc05/MyTemplate/blob/env/.jerryc05.zinit.sh).
  - Append these lines to `~/.zshrc` to enable it:
    ```sh
    (
      cd $HOME &&\
      curl -JOL https://raw.githubusercontent.com/jerryc05/MyConfig/master/env/%24HOME/.jerryc05.aliases.sh &&\
      curl -JOL https://raw.githubusercontent.com/jerryc05/MyConfig/master/env/%24HOME/.jerryc05.env.sh &&\
      curl -JOL https://raw.githubusercontent.com/jerryc05/MyConfig/master/env/%24HOME/.jerryc05.zinit.sh
    ) &&\
    echo 'for f in $HOME/.jerryc05.*.sh; do . $f; done' >> $HOME/.zshrc
    ```

#### Summary

- Make sure you have `git`, `less`, `tar`, `gzip` installed
- Make sure `echo $langinfo[CODESET]` prints someting like `UTF-8`
- **[OPTIONAL]** Change terminal's font to one that supports **Emoji** (or at least **Unicode**) characters.
    - Some recommended font-families:
        - [Cascadia Code](https://github.com/microsoft/cascadia-code) (my top choice)
        - [Fira Code](https://github.com/tonsky/FiraCode) (quite good)
        - [MesloLGS NF](https://github.com/romkatv/powerlevel10k/blob/master/font.md) (used by `p10k` theme, but not really recommended)
    - If you decided to change terminal's font, make sure to:
        - Download all fonts in the font-family (e.g. `Regular`, `Bold`, etc).
        - Install all fonts in the font-family.
        - Change the font of the terminal.
- Restart terminal.
- If you are using `powerlevel10k` (default theme of this tutorial):
    -   Run the following script in terminal (just for customization):
        ```sh
        scr="\
        -e 's/# *node_version/node_version/g' \
        -e 's/# *go_version/go_version/g' \
        -e 's/# *rust_version/rust_version/g' \
        -e 's/# *dotnet_version/dotnet_version/g' \
        -e 's/# *php_version/php_version/g' \
        -e 's/# *laravel_version/laravel_version/g' \
        -e 's/# *java_version/java_version/g' \
        -e 's/# *package/package/g' \
        -e 's/# *vpn_ip/vpn_ip/g' \
        -e 's/# *disk_usage/disk_usage/g' \
        -e 's/# *ram/ram/g' \
        -e 's/^\( *\)context/#\1context/g'"
        eval "sed $scr -i ~/.p10k.zsh || sed $scr -i '' ~/.p10k.zsh"
        . ~/.p10k.zsh
        ```
    -   You can tweak `~/.p10k.zsh` yourself as well if you are interested.
        -   Don't forget to run `. ~/.p10k.zsh` afterwards to apply changes.
