## Before build
```sh
sudo apt install pkg-config libudev-dev libpam0g
```

## After build
0.  Create directory `data`
0.  Copy `examples/server.toml` to `./data/`
0.  Edit `./server.toml`:
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