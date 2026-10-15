---
name: known-errors
description: >
  Diagnose errors when calling FChat tools: authentication failures, wrong shop, missing permissions,
  invalid parameters or date formats, empty results, mismatched figures. Use when an FChat tool errors
  or returns something odd, or the user says "sao không ra dữ liệu", "số liệu sai", "FChat lỗi".
metadata:
  version: "0.1.0"
---

# Known errors

Treat the error message returned by the tool as authoritative. Do not retry repeatedly with the same failing parameters.

## Authentication and permissions

- **401, expired token, no FChat tools visible:** the login session expired or never happened. Follow the login section in `fchat-basics`. Reinstalling the plugin does not fix this.
- **Cannot sign in, "Email hoặc mật khẩu không đúng":** accounts created with Facebook login have no password. The user must set one in FChat first.
- **Wrong shop:** `get_shop_info` returns a different shop than the user wants. The user must disconnect, sign in again and choose the right shop.
- **Fewer pages or data than expected:** the user's role in the shop limits which pages they can see. Results follow their permissions; this is not a bug.
- **422 "Token hết hạn":** the session ended mid-task. Ask the user to sign in again, then retry once.

## Parameters

- **Validation error:** re-read the tool schema and change only the rejected field. The most common cause is the date format: `DD/MM/YYYY - DD/MM/YYYY` for `date_filter`, `YYYY-MM-DD` for `get_orders`, `DD/MM/YYYY` for `get_posts`.
- **Id not found:** the record was deleted, belongs to another page, or an id from another tool was used (e.g. a customer `_id` where a `sender_id` is expected). Look it up again with the matching list tool.

## Results

- **Empty:** check the page, the time range and the filters. Widen the time range once, then tell the user there is no data, including the filters used.
- **Figures differ between two tools:** reports may count conversations, customers and orders differently. Report each tool's number as is instead of adjusting them to match.

## Server errors

HTTP 5xx or timeout: the FChat service is temporarily unstable. Retry once after a few seconds; if it still fails, tell the user and stop rather than retrying in a loop.
