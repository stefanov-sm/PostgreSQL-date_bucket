# PostgreSQL-date_bucket
PostgreSQL implementation of SQL-standard `date_bucket()` function  

Signature
```sql
function date_bucket(dpart text, dpart_count integer, ts timestamptz, origin timestamptz default 'epoch')
returns timestamptz;
```
Example
```sql
 select current_timestamp, date_bucket('seconds', 10, current_timestamp);
```
|current_timestamp            |date_bucket                  |
|-----------------------------|-----------------------------|
|2023-10-11 09:14:52.925 +0300|2023-10-11 09:14:50.000 +0300|
