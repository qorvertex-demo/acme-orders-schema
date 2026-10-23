-- Core order-taking schema. Owned by this repository; the API and reporting
-- services connect to the same database and never define tables themselves.

CREATE TABLE IF NOT EXISTS customers (
    id            BIGSERIAL PRIMARY KEY,
    email         TEXT        NOT NULL UNIQUE,
    display_name  TEXT        NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS orders (
    id            BIGSERIAL PRIMARY KEY,
    customer_id   BIGINT      NOT NULL REFERENCES customers (id) ON DELETE RESTRICT,
    status        TEXT        NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled')),
    total_cents   INTEGER     NOT NULL DEFAULT 0 CHECK (total_cents >= 0),
    placed_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS order_items (
    id            BIGSERIAL PRIMARY KEY,
    order_id      BIGINT      NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    sku           TEXT        NOT NULL,
    quantity      INTEGER     NOT NULL CHECK (quantity > 0),
    unit_cents    INTEGER     NOT NULL CHECK (unit_cents >= 0)
);

CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders (customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items (order_id);
