## Every connection
```sql

```

## One time
```sql
SET PERSIST slow_query_log  = 1;
SET PERSIST long_query_time = 1;
SET PERSIST log_queries_not_using_indexes=1;  
SET PERSIST log_throttle_queries_not_using_indexes=10;

SET PERSIST character_set_client     = 'utf8mb4';
SET PERSIST character_set_connection = 'utf8mb4';
SET PERSIST character_set_database   = 'utf8mb4'; 
SET PERSIST character_set_results    = 'utf8mb4';
SET PERSIST character_set_server     = 'utf8mb4'; 
```