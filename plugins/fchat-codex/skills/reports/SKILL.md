---
name: reports
description: >
  Build FChat reports for the shop owner: overview of conversations, customers, orders and revenue;
  per-page comparison; new customers; staff response time; Facebook Ads results; AI credit usage;
  stock in and out. Use when the user asks e.g. "báo cáo hôm nay", "tình hình tuần này",
  "so sánh với tuần trước", "page nào nhiều tin nhắn nhất", "nhân viên nào trả lời chậm",
  "quảng cáo có hiệu quả không", "tốn bao nhiêu credit AI", "giờ nào khách nhắn nhiều".
metadata:
  version: "0.1.0"
---

# Reports

Every statistics tool takes `date_filter` as `DD/MM/YYYY - DD/MM/YYYY`; most also take `pages` (one or more `page_id`, comma-separated; empty = all pages). If the user gives no range, use the last 7 days and say so.

## Which tool

| Question | Tool |
|---|---|
| Overall picture: conversations, customers interacted, new customers, orders and revenue, peak hours, daily chart, per-page table | `get_message_statistics` (`get_statistics` is a lighter shop overview) |
| Compare pages | `get_page_statistics` (conversations, messages, new customers per page) or `get_page_performance` (per page plus tag usage and top tags) |
| Customers over the period, top staff, top posts | `get_contact_statistics` |
| New customers in detail | `get_new_contact_statistics` |
| Conversations and interactions, new vs returning customers, closing rate, per staff | `get_conversation_statistics` |
| Staff response time and performance | `get_response_time_statistics` |
| Facebook Ads results (spend, ROAS, CPL, CPA) | `get_ads_statistics` (optional `ad_id`) |
| AI chatbot credit usage | `get_credit_statistics` |
| Stock in and out | `get_store_statistics` (`stores`: leave empty for all; no tool lists store ids) |

## Comparing periods

For "compared with last week/month", call the same tool twice with ranges of equal length (e.g. the last 7 days and the 7 days before) and report the change as a number and a percentage. Do not compare a partial period with a full one without saying so.

## Morning report

When the user asks for a quick daily report, combine:

1. `get_message_statistics` for yesterday (or today so far) and the same day last week.
2. Unanswered conversations: `get_conversations` with `no_answer: true` and today's `date_filter` (see `conversations`).
3. New orders not yet processed: `get_orders` with `status: 1` (see `orders`).

## Presenting

- Start with three to five headline figures and the change versus the previous period, then the notable points (best and worst page, peak hour, slow responders).
- Use a small table for per-page or per-staff comparisons. Money in VND with dot separators.
- Report each tool's numbers as returned; tools may count differently, so do not force them to match.
