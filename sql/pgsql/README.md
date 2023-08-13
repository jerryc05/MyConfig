0.  Config files are usually in dir `/etc/postgresql/PGSQL_VERSION/DB_NAME/`
0.  Use [PGTune](https://github.com/le0pard/pgtune) to generate `postgresql.conf` 
0.  Use the following for non-sensitive db in `postgresql.conf`:
    ```conf
    synchronous_commit = off 
    wal_compression = zstd

    listen_addresses = '*'

    # If don't want WAL replication/archive/streaming
    max_wal_senders = 0
    wal_level = minimal
    ```
0.  Change password of user `postgres`:
    ```sh
    sudo -u postgres psql    
    ```
    ```sql
    \password postgres
    ```
0.  Change auth method to password in `pg_hba.conf`:
    ```conf            
    # Allow WAN connections
    host    all             all             0.0.0.0/0               scram-sha-256
    host    all             all             ::/0                    scram-sha-256
    ```
0.  Reload:
    ```sql
    SELECT pg_reload_conf();
    ```
    or restart:
    ```sh
    sudo systemctl restart postgresql
    ```