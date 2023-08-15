## Before build
```sh
# Ubuntu/Debian
sudo apt install pkg-config libudev-dev libpam0g
```

## Building (server)
0.  Goto `server/daemon`
0.  Built it!

## After build (server)
0.  Goto `server/`
0.  Create directory `./bin/data/` (or any other name), and go into `./bin/`
0.  Symlink `kanidmd` here
0.  Copy `examples/server.toml` to `./data/`
0.  Directory looks like:
    ```
    $ tree
    .
    ├── data
    │   └── server.toml
    └── kanidmd -> ../../target/x86_64-unknown-linux-gnu/release/kanidmd
    ```
0.  Edit `./data/server.toml`:
    ```toml
    bindaddress = "[::]:8443"
    trust_x_forward_for = true
    db_path     = "./data/kanidm.db"
    tls_chain   = ???
    tls_key     = ???
    domain      = ???
    origin      = "https://???:???"

    [online_backup]
    path        = "./data/backups/"
    schedule    = "@hourly"
    ```
    Validate config:
    ```sh
    ./kanidmd configtest -c ./data/server.toml
    ```
0.  Systemd:
    ```sh
    SYSTEMD_DIR_='/etc/systemd/system'
    sudo mkdir -p $SYSTEMD_DIR_/kanidmd.service.d/
    sudo cp ../../examples/systemd/kanidmd.service $SYSTEMD_DIR_/
    cat <<EOF | sudo tee $SYSTEMD_DIR_/kanidmd.service.d/override.conf
    [Service]
    ExecStart=
    ExecStart="$(pwd)/kanidmd" server -c "$(pwd)/data/server.toml"
    RestartSec=1s
    WorkingDirectory="$(pwd)"
    DynamicUser=no
    User=$(whoami)
    EOF
    ```

### Start (server)
```sh
sudo systemctl enable kanidmd 
sudo systemctl start kanidmd
systemctl status kanidmd
```

## Building (client)
0.  Goto `tools/cli`
0.  Built it!

## After build (client)
```sh
cat <<EOF >~/.config/kanidm
uri="https://[::1]:????"
verify_ca = false
EOF
```