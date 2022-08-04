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

0.  Run `LxRunOffline.exe i -r root.x86_64 -n <any_distro_name_you_want> -d <install_location> -f <bootstrap_file>`

# 2. Configure `Arch Linux`

0.  WSL2 Linux Kernel update: https://www.catalog.update.microsoft.com/Search.aspx?q=wsl

0.  Set as WSL2 (windows): `wsl --set-version <distro_name> 2`

0.  Launch `Arch Linux`

0.  Fix `/usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link`
    ```
    cd /mnt/c/Windows/System32/lxss/lib/
    mv libcuda.so.1 ~libcuda.so.1
    mv libcuda.so   ~libcuda.so
    ln -s libcuda.so.1.1 libcuda.so.1
    ln -s libcuda.so.1.1 libcuda.so
    ```

0.  ```
    pacman-key --init
    pacman-key --populate
    ```

0.  Edit `/etc/pacman.conf`, uncomment the line `Color` and `ParallelDownloads` under `# Misc options` and save. E.g.:
    ```
    sed -i s/^#Color/Color/ /etc/pacman.conf
    sed -i s/^#VerbosePkgLists/VerbosePkgLists/ /etc/pacman.conf
    sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 16\nILoveCandy/' /etc/pacman.conf
    ```

0.  Edit `/etc/locale.gen`, uncomment the line of locale you want to use, save it, and run `locale-gen`. E.g.:
    ```
    sed -i s/^#en_US.UTF-8/en_US.UTF-8/ /etc/locale.gen
    locale-gen
    ```

0.  Backup `/etc/pacman.d/mirrorlist`:
    ```
    mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist~
    #awk '/^## Worldwide$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 2);}' /etc/pacman.d/mirrorlist~ \
      >>/etc/pacman.d/mirrorlist
    #awk '/^## United States$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 2);}' /etc/pacman.d/mirrorlist~ \
      >>/etc/pacman.d/mirrorlist
    ```

0.  Update mirrors with [`reflector`](https://wiki.archlinux.org/title/Reflector), and then rank mirrors with [`rankmirrors`](https://wiki.archlinux.org/title/Mirrors#List_by_speed), by
    ```
    pacman -S reflector rsync
    TMP=`mktemp`
    reflector --sort score -p http,https -c ",United States" --save "$TMP" --verbose --connection-timeout 1 --download-timeout 1

    pacman -S pacman-contrib
    rankmirrors -v $TMP | tee /etc/pacman.d/mirrorlist
    ```

0.  ```
    pacman -Sy archlinux-keyring
    pacman -Syu
    gpgconf --kill all
    ```

0.  *Optional:* Set password for `root` user: `passwd`

0.  `sudo`:
    1.  `pacman -S sudo`
    2.  Edit `/etc/sudoers`, uncomment the `# %sudo ALL=(ALL) ALL` and save:
        ```
        sed -i "s/^# %sudo$(printf '\t')ALL/%sudo$(printf '\t')ALL/" /etc/sudoers
        ```
        or uncomment below to allow any user to run sudo if they know the password:
        ```
        # Defaults targetpw  # Ask for the password of the target user
        # ALL ALL=(ALL:ALL) ALL  # WARNING: only use this together with 'Defaults targetpw'
        ```
    
0.  Setup performance optimizations
    ```
    echo 'ALL ALL=(ALL) NOPASSWD: /etc/mount_root_optim.sh'       >/etc/sudoers.d/mount_root_optim
    printf '#!/bin/sh\nmount -o remount,lazytime,noatime /'       >/etc/mount_root_optim.sh
    printf 'mount -o remount,commit=60,barrier=0 /'   >>/etc/mount_root_optim.sh  # Only for Ext4
    //                                            └ Turn this off only when using battery-backed cache
    chmod +x /etc/mount_root_optim.sh
    ROOT_DEVICE=$(df /|head -2|tail -1|cut -d ' ' -f1)
    tune2fs -O "^has_journal"         $ROOT_DEVICE  # Only for Ext4
    tune2fs -o journal_data_writeback $ROOT_DEVICE  # Only for Ext4
    tune2fs -o discard                $ROOT_DEVICE  # Only for SSD
    echo 'sudo /etc/mount_root_optim.sh'                        >/etc/profile.d/mount_root_optim.sh
    ```

    Append the following to `%userprofile%/.wslconfig` in Windows:
    ```
    [wsl2]
    kernelCommandLine = "noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off tsx=on tsx_async_abort=off mitigations=off"'
    ```

0.  Add new user:
    1.  Add:
        1.  admin user: `groupadd sudo; useradd -G sudo -m <username>`
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
                <uid>
                ```
            2.  `LxRunOffline`:
                ```
                LxRunOffline.exe su -n <distro_name> -v <uid>
                ```

0.  Login with user other than `root` and install `yay` (or `paru`):
    ```
    cd `mktemp -d`
    curl -JOL https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay-bin
    sudo pacman -S binutils
    makepkg -si
    ```