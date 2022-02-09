pragma synchronous = off;      -- off | normal | full
pragma journal_mode = memory;  -- off | memory | persist | truncate | wal | delete
pragma temp_store = memory;
pragma foreign_keys = on;
-- sqlite3 db.sqlite3 "vacuum"

.headers on
.mode column
