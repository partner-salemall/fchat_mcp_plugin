---
name: customers
description: >
  Look up FChat customers (audiences): search by name, phone or email, view a customer profile,
  list customers of a page or with a tag, and see their conversations and orders. Use when the user
  asks e.g. "tìm khách số 09...", "khách tên Lan", "thông tin khách này", "khách có tag VIP",
  "danh sách khách của page X", "khách này đã mua gì".
metadata:
  version: "0.1.0"
---

# Customers

## Find customers

- By name, phone or email: `search_audiences` (`keyword`).
- Customers of one page: `get_audiences` (`page_id`, optional `keyword` for the name only, `page`, `limit` up to 100).
- Customers with a tag: get the tag `_id` with `get_tags`, then `get_audiences` with `tag_id`.

Search may return near matches. Check the results against what the user typed (exact phone number, accented name) and say if unrelated customers were mixed in.

## Customer profile

1. `get_audience_detail` (`id`, `page_id`): contact details, tags, notes, last message time, status, custom attributes.
2. Their conversations: `get_conversations` with `sender_id` (see `conversations`).
3. Their orders: `get_orders` with `sender_id` (see `orders`).

Combine these into a short profile: who they are, latest interaction, open issues, order history.

## Presenting

- Lists: name, page, tags, last interaction. Mask phone numbers in lists (e.g. 090****123); show full contact details only for a single customer the user asked about.
- The plugin cannot edit customers, tags or notes yet; direct the user to FChat for changes.
