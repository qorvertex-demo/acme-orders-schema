> **Part of the [QorVertex live demo](https://qorvertex.com).** A small sample application that shows a shared PostgreSQL database: one repository owns the schema, others read and write it, and a deployment repository wires them together. It is intentionally minimal and not production code.

# acme-orders-schema

Owns the schema for the `acme_orders` database.

Two services share this database and neither creates tables of its own:

- **acme-orders-api** (Node) — writes `customers`, `orders`, `order_items`;
  calls the `recalc_order_total` procedure.
- **acme-orders-reporting** (Python) — reads `orders`, `order_items`,
  `customers` and the `order_totals` view.

```bash
npm install
DATABASE_URL=postgresql://user:pass@host:5432/acme_orders npm run migrate
```
