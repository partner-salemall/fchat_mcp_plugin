---
name: shop-info
description: >
  View FChat shop information: the current shop, connected pages and channels (Facebook, Zalo OA,
  Zalo personal, Instagram, website, Telegram, AI), page details and the staff list. Use when the user
  asks e.g. "shop đang kết nối những page nào", "page nào đang offline", "có những nhân viên nào",
  "đã kết nối Zalo chưa", "đang làm việc trên shop nào".
metadata:
  version: "0.1.0"
---

# Shop information

- Current shop: `get_shop_info`. The shop is the one the user chose when signing in; to switch shops they must disconnect and sign in again (see `fchat-basics`).
- Pages: `get_pages` lists every page in the shop, online pages first. `get_page_detail` (`page_id`) shows one page's type, status and settings.
- Channels by type: `get_connected_channels` (`type`: 0 = Facebook, 1 = Zalo OA, 2 = Website, 3 = Instagram, 7 = Telegram, 8 = AI, 9 = Zalo personal).
- Staff: `get_agents` returns each staff member's `_id`, name and type. That `_id` is the `sale_id` used by conversation and order filters.

## Presenting

- Group pages by channel and mark the ones that are disconnected or offline, since they stop receiving messages.
- Never show page access tokens or other secrets that appear in tool output.
- The pages and staff the user sees depend on their role in the shop. If something seems missing, say it may be outside their permissions.
