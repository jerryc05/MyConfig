## Before build
```sh
# Ubuntu/Debian
sudo apt install pkg-config libudev-dev libpam0g
```

## After build
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

## Start
```sh
./kanidmd server -c ./data/server.toml
```