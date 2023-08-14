-- ONCE
pragma synchronous = off;      -- off | normal | full; use [normal] when serious
pragma journal_mode = memory;  -- off | memory | persist | truncate | wal | delete; use [wal] when serious
PRAGMA wal_autocheckpoint = 10;   -- default is 1000
pragma temp_store = memory;
pragma auto_vacuum = incremental;
pragma mmap_size = 17179869184; -- 16 GiB
pragma page_size = 16384;       -- 16 KiB

-- -- Think before doing this
pragma foreign_keys = on;



-- REGULARLY
pragma vacuum;  -- VERY EXPENSIVE!!! Or use incremental version below

pragma incremental_vacuum;  -- Must have [auto_vacuum = incremental]

pragma optimize;    -- it is recommended that applications run "PRAGMA optimize" (with no arguments) just before closing each database connection. 
                    -- Long-running applications might also benefit from setting a timer to run "PRAGMA optimize" every few hours.



-- -- Visual improvements
.headers on
.mode column
