# TimescaleDB Discovery

Small project I created to get familiar with TimescaleDB and some of its features.

I used a simple application monitoring dataset with around 260k rows containing response times, CPU and memory usage, HTTP status codes and different services.

## What I tried

- Creating a TimescaleDB hypertable
- Working with time-based data and `time_bucket()`
- Using `EXPLAIN ANALYZE` to understand query plans
- Adding a composite index and comparing the query before and after
- Creating a continuous aggregate for 5-minute application metrics
- Using `pg_stat_statements` to look at query statistics

## Query optimization

I tested a query returning the last 7 days of metrics for one service.

At first PostgreSQL was using the time index and filtering the results by service. I added an index on:

```sql
(service, time DESC)
```

After that both conditions were used directly by the index. In my test the execution time went from around 10 ms to around 4-5 ms.

## Continuous aggregates

I also created a continuous aggregate with 5-minute buckets for response times, request count and errors.

For my test data, querying the continuous aggregate took around 4 ms compared to around 43 ms when calculating the same aggregation from the raw data.

The SQL used for the different experiments is available in the `sql` folder.