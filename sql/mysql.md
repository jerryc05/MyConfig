## For profiling, do not leave them on in prod
```sql
SET PERSIST slow_query_log  = ON;
SET PERSIST long_query_time = .5;

SET PERSIST performance_schema = ON;
-- SET PERSIST performance_schema = ON; -- Turn off for better performance
```

## Common config
```sql
SET PERSIST character_set_client     = 'utf8mb4';
SET PERSIST character_set_connection = 'utf8mb4';
SET PERSIST character_set_database   = 'utf8mb4'; 
SET PERSIST character_set_results    = 'utf8mb4';
SET PERSIST character_set_server     = 'utf8mb4'; 

SET PERSIST innodb_buffer_pool_size = 536870912; -- 50%~75% system memory

SET PERSIST sql_safe_updates = 1;
```

## Trade consistency for speed
```sql
-- 1 (default): flush to disk on every commit. Use it for critical transactions like money. 
-- 0: flush to page cache only every second. Use it for non-critical transactions.
SET PERSIST innodb_flush_log_at_trx_commit = 0;

SET PERSIST innodb_use_fdatasync = ON;
```