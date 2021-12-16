# 1. Install `Arch Linux`

## 1. Use `ArchWSL`

See https://github.com/yuk7/ArchWSL

## 2. Use `wsldl` (might not work properly)

0.  Download `Launcher.exe` from https://github.com/yuk7/wsldl

0.  Rename `Launcher.exe` to any distro name you want, e.g. `Arch.exe`

0.  Download latest bootstrap iso `archlinux-bootstrap-????.??.??-x86_64.tar.gz` from https://archlinux.org/download/

0.  Rename `archlinux-bootstrap-????.??.??-x86_64.tar.gz` to `rootfs.tar.gz`

0.  Run `Arch.exe` (formerly `Launcher.exe`)

## 3 Use `LxRunOffline`

0.  Download and unzip `LxRunOffline.exe` from https://github.com/DDoSolitary/LxRunOffline

0.  Download latest bootstrap iso `archlinux-bootstrap-????.??.??-x86_64.tar.gz` from https://archlinux.org/download/

0.  Run `LxRunOffline.exe i -r root.x86_64 -n <any_distro_name_you_want> -d <install_location> -f <bootstrap_iso>`

# 2. Configure `Arch Linux`

0.  WSL2 Linux Kernel update: https://www.catalog.update.microsoft.com/Search.aspx?q=wsl

0.  Set as WSL2 (windows): `wsl --set-version <distro_name> 2`

0.  Launch `Arch Linux`

0.  ```
    pacman-key --init
    pacman-key --populate
    ```

0.  Edit `/etc/pacman.d/mirrorlist`, uncomment all mirrors you want to enable

0.  ```
    pacman -Syyu
    pacman -S archlinux-keyring 
    gpgconf --kill all
    ```

0.  Edit `/etc/pacman.conf`, uncomment the line `Color` under `# Misc options` and save

0.  Locale:
    1.  `pacman -S sed`
    2.  Edit `/etc/locale.gen`, uncomment the line of locale you want to use, save it, and run `locale-gen`

0.  Set password for `root` user: `passwd`

0.  `sudo`:
    1.  `pacman -S sudo`
    2.  Edit `/etc/sudoers`, uncomment the following lines and save:
        ```
        # %wheel ALL=(ALL) ALL
        ```
        ```
        # Defaults targetpw  # Ask for the password of the target user
        # ALL ALL=(ALL) ALL  # WARNING: only use this together with 'Defaults targetpw'
        ```

0.  Add new user:
    1.  Add:  
        1.  admin user: `useradd -m -G wheel <username>`
        2.  normal user: `useradd -m <username>`
    
    2.  Set password: `passwd <username>`

    3.  Set default login user (windows):
        1.  `wsldl`:
            ```
            <Arch.exe> config --default-user <username>
            ```
        2.  `LxRunOffline`:
            1.  Get `uid` of user:
                ```
                $ id -u <username>
                uid=1000(username) ...
                ```
                In this case, `uid` is `1000`
            2.  `LxRunOffline`:
                ```
                LxRunOffline.exe su -n <distro_name> -v <uid>
                ```

0.  Login with user other than `root` and install `yay`:
    ```
    cd /tmp
    curl -JOL https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay-bin
    makepkg -si
    ```
