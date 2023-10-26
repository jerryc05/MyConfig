## Key Eviction Policy
Add to `redis.conf`:
```
# > CONFIG SET ...
maxmemory-policy allkeys-lfu
```