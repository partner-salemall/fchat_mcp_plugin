# fchat plugin

Connects Claude to the FChat MCP server at `https://api.fchat.vn/mcp` (streamable HTTP, OAuth 2.1 + PKCE).

No environment variables or tokens needed: Claude Code runs OAuth itself on `claude mcp login plugin:fchat:fchat`, or when the user chooses Authenticate in `/mcp`. The user signs in with their FChat email and password, then chooses a shop.

## Skills

| Skill | When it is used |
|---|---|
| `fchat-basics` | Every FChat request: sign-in, page and id lookup rules, date formats, presentation, data safety |
| `conversations` | Unread or unanswered chats, message history, summaries, reply drafts, assigned chats |
| `customers` | Customer search, profiles, customers by page or tag |
| `orders` | Orders by date, status, staff or customer |
| `reports` | Overview and per-page reports, response time, ads, AI credits, stock |
| `automation` | Flows, message blocks, sequences, auto-reply keywords, posts |
| `shop-info` | Current shop, pages and channels, staff list |
| `known-errors` | Diagnosing auth, permission, parameter and empty-result errors |

This is the source of truth for the skills. The Codex plugin (`plugins/fchat-codex`) uses copies of every skill except `fchat-basics`; after editing a skill, run `node scripts/sync-skills.mjs`.

## Install

```
claude plugin marketplace add partner-salemall/fchat_mcp_plugin
claude plugin install fchat@fchat
```
