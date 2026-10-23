-- Recomputes an order's cached total from its items. The API calls this after
-- mutating items so `orders.total_cents` never drifts from `order_items`.
CREATE OR REPLACE PROCEDURE recalc_order_total(p_order_id BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total INTEGER;
BEGIN
    SELECT COALESCE(SUM(quantity * unit_cents), 0)
      INTO v_total
      FROM order_items
     WHERE order_id = p_order_id;

    UPDATE orders
       SET total_cents = v_total,
           updated_at  = now()
     WHERE id = p_order_id;
END;
$$;
