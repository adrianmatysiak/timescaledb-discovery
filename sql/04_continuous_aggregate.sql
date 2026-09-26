CREATE MATERIALIZED VIEW app_metrics_5min
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('5 minutes', time) AS bucket,
    service,
    avg(response_ms) AS avg_response_ms,
    max(response_ms) AS max_response_ms,
    count(*) AS requests,
    count(*) FILTER (WHERE status_code >= 500) AS errors
FROM app_metrics
GROUP BY bucket, service
WITH NO DATA;


CALL refresh_continuous_aggregate(
    'app_metrics_5min',
    now() - interval '30 days',
    now()
);


SELECT add_continuous_aggregate_policy(
    'app_metrics_5min',
    start_offset => INTERVAL '30 days',
    end_offset => INTERVAL '10 minutes',
    schedule_interval => INTERVAL '5 minutes'
);


-- Query precomputed 5-minute metrics.

SELECT
    bucket,
    service,
    avg_response_ms,
    max_response_ms,
    requests,
    errors
FROM app_metrics_5min
WHERE bucket > now() - interval '7 days'
ORDER BY bucket DESC, service;