0.  Use [PGTune](https://github.com/le0pard/pgtune) to generate `postgresql.conf` 
0.  Use the following for non-sensitive db:
    ```conf
    synchronous_commit = off 
    wal_compression = zstd


    wal_level = minimal
    ```