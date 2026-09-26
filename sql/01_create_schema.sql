create table app_metrics (
    time        TIMESTAMPTZ NOT NULL,
    service     TEXT NOT NULL,
    endpoint    TEXT NOT NULL,
    response_ms INTEGER NOT NULL,
    cpu_percent DOUBLE PRECISION,
    memory_mb   INTEGER,
    status_code INTEGER NOT NULL
);

SELECT create_hypertable('app_metrics', by_range('time'));