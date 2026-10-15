---
name: automation
description: >
  Review FChat automation and content: chatbot flows, message blocks (scripts), care sequences,
  auto-reply keywords for comments and inbox, and Facebook posts. Use when the user asks e.g.
  "page này có những flow nào", "kịch bản chào khách viết gì", "sequence chăm sóc gồm mấy bước",
  "từ khoá tự động trả lời comment", "bài viết đã lên lịch", "rà soát kịch bản chatbot".
metadata:
  version: "0.1.0"
---

# Automation and content

All of these are per page: get the `page_id` with `get_pages` first.

## Chatbot

- Flows: `get_flows` (grouped), then `get_flow_detail` (`flow_id` from the `bots` array) for steps, buttons and conditions.
- Message blocks (the "Danh sách tin nhắn" scripts): `get_message_blocks`, then `get_message_block_detail` (`page_id`, `block_id`).
- Care sequences: `get_sequences` returns each sequence with its trigger tag, status and send steps (`bots`); read the steps there. `get_sequence_detail` (`sequence_id`) only returns the name, linked tag and status.
- Pass `refresh: true` only when the user says they just changed something and the list looks stale.

## Auto-reply keywords

`get_keywords` (`page_id` required; `type` 1 = comment, 2 = inbox; `status` 0 = off, 1 = on; `keyword` searches the rule text or a post id), then `get_keyword_detail` (`id`).

## Posts

`get_posts` (`pages`, `keyword`, `status_post`, `start_date` / `end_date` as `DD/MM/YYYY`). `status_post`: 0 = draft, 1 = published, 2 = scheduled but overdue, 3 = scheduled and waiting.

## Reviewing

When the user asks you to review automation, look for: steps with empty or placeholder text, broken or missing buttons, sequences with no linked tag, overlapping keywords that would trigger the same reply, keywords switched off, and scheduled posts that are overdue. Report findings as a short list with the item name and what to fix.

The plugin cannot create or edit flows, sequences, keywords or posts yet; changes must be made in FChat.
