INSERT INTO app_metrics
    (time, service, endpoint, response_ms, cpu_percent, memory_mb, status_code)
SELECT
    ts,
    (ARRAY['api', 'auth', 'payments', 'notifications'])
        [1 + floor(random() * 4)::int],
    (ARRAY['/login', '/users', '/orders', '/payments', '/health'])
        [1 + floor(random() * 5)::int],
    (20 + random() * 480)::int,
    10 + random() * 80,
    (200 + random() * 1800)::int,
    CASE
        WHEN random() < 0.95 THEN 200
        ELSE 500
    END
FROM generate_series(
    now() - interval '30 days',
    now(),
    interval '10 seconds'
) AS ts;