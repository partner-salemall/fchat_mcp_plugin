---
name: conversations
description: >
  Look up and work through FChat conversations (Messenger, Zalo, Instagram, website chat, comments):
  unread or unanswered chats, a customer's conversation, message history, summaries, reply drafts,
  tag suggestions and chats assigned to a staff member. Use when the user asks e.g.
  "hội thoại nào chưa trả lời", "tin nhắn chưa đọc", "khách A nhắn gì", "tóm tắt hội thoại",
  "soạn câu trả lời cho khách", "nhân viên B đang giữ những hội thoại nào", "comment bài viết X".
metadata:
  version: "0.1.0"
---

# Conversations

## Find conversations

- Filtered list: `get_conversations`. Useful filters: `page_id`, `no_read` (unread), `no_answer` (no staff reply yet), `no_owner` (not assigned), `is_done`, `content_type` (0 = inbox, 1 = comment), `sale_id`, `tag`, `post_id`, `ads_id`, `date_filter` (`DD/MM/YYYY - DD/MM/YYYY`).
- By customer name or message text: `search_conversations` (`keywords`, optional `page_id`, `content_type`).
- One customer's conversations: `get_conversations` with `sender_id`.
- Assigned to a staff member: get the staff `_id` with `get_agents`, then `get_assigned_conversations` (`status`: all, new, processing, done).

For "today" or "recently", set `date_filter` to today or the last 7 days and say which range you used.

## Read one conversation

1. `get_conversation_detail` (`id`) for the customer, status, assigned staff and tags.
2. `get_latest_messages` for a quick look, or `get_conversation_messages` (page 1 = newest) for the full history.
3. For a summary, `summarize_conversation` returns the context in one call; write the summary yourself: what the customer wants, what was promised, what is still open.

## Draft a reply

`draft_reply` (`conv_id`, optional `instruction`) returns context only; it never sends anything. Write the draft from that context in the shop's tone, show it to the user, and tell them to send it from FChat. Do not invent prices, stock or policies that are not in the conversation; mark them as something the user must fill in.

## Suggest tags

`get_tags` lists the page's tags; `suggest_contact_tags` (`page_id`, `conv_id`) returns tags plus conversation context so you can pick the best ones. Present suggestions only; tagging must be done in FChat.

## Presenting

- Lists: one line per conversation with customer name, page, last message time, status (unread / unanswered / done) and assigned staff. At most 20 lines, plus the total.
- Put conversations waiting longest without a reply first; flag ones waiting more than a few hours.
- Quote customer messages briefly; do not paste whole histories unless asked.
