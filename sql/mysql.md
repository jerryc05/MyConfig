## For profiling, do not leave them on in prod
```sql
SET PERSIST slow_query_log  = 1;
SET PERSIST long_query_time = .5;

SET PERSIST performance_schema = 1;
```

## Common config
```sql
SET PERSIST character_set_client     = 'utf8mb4';
SET PERSIST character_set_connection = 'utf8mb4';
SET PERSIST character_set_database   = 'utf8mb4'; 
SET PERSIST character_set_results    = 'utf8mb4';
SET PERSIST character_set_server     = 'utf8mb4'; 

SET PERSIST innodb_buffer_pool_size = 536870912; -- 50%~75% system memory
```