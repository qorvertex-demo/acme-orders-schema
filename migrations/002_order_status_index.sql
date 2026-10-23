-- Reporting filters heavily on status + placed_at; without this the daily
-- rollup sequential-scans the whole orders table.
CREATE INDEX IF NOT EXISTS idx_orders_status_placed ON orders (status, placed_at DESC);
