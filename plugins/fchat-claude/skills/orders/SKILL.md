---
name: orders
description: >
  Look up FChat orders: today's or recent orders, orders by status, by staff member or by customer,
  and search by customer name, phone or order code. Use when the user asks e.g. "đơn hôm nay",
  "đơn mới chưa xử lý", "đơn của khách 09...", "đơn bị huỷ tuần này", "nhân viên A chốt được bao nhiêu đơn".
metadata:
  version: "0.1.0"
---

# Orders

## Find orders

`get_orders` covers every case:

- `start_date` / `end_date` in `YYYY-MM-DD` (note: not the `DD/MM/YYYY` format used by conversations).
- `status`: 1 = new, 2 = processing, 3 = completed, 4 = cancelled.
- `keywords`: customer name, phone or order code.
- `sender_id`: one customer's orders (get it from `search_audiences` or the conversation).
- `sale_id`: one staff member's orders (get it from `get_agents`).
- `page_id`: one page.

If the user just says "today's orders" or "recent orders", use today or the last 7 days and state the range.

For revenue totals over a period, prefer `get_message_statistics` (see `reports`) rather than adding up order pages yourself.

## Presenting

- One line per order: code, customer, total, status, created date. At most 20 lines, plus the total count.
- Call out new orders that have not moved to processing for a long time.
- Mask phone numbers and addresses in lists; show them in full only for a single order the user asked about.
- The plugin only reads orders. Creating, editing or cancelling orders must be done in FChat.
