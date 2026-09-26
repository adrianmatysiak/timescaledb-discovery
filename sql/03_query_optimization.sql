-- Inspect the initial execution plan.

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM app_metrics
WHERE service = 'payments'
  AND time > now() - interval '7 days'
ORDER BY time DESC;


-- Add a composite index matching the service + time access pattern.

CREATE INDEX idx_app_metrics_service_time
ON app_metrics (service, time DESC);


-- Compare the execution plan after adding the index.

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM app_metrics
WHERE service = 'payments'
  AND time > now() - interval '7 days'
ORDER BY time DESC;