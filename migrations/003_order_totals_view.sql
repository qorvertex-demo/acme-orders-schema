-- Both services read this instead of re-deriving the join.
CREATE OR REPLACE VIEW order_totals AS
SELECT o.id            AS order_id,
       o.customer_id,
       c.email         AS customer_email,
       o.status,
       o.placed_at,
       COALESCE(SUM(i.quantity * i.unit_cents), 0)::INTEGER AS computed_cents,
       COUNT(i.id)                                          AS item_count
  FROM orders o
  JOIN customers c   ON c.id = o.customer_id
  LEFT JOIN order_items i ON i.order_id = o.id
 GROUP BY o.id, o.customer_id, c.email, o.status, o.placed_at;
