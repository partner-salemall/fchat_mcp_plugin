# FChat for Claude and Codex

The official plugin connecting Claude Code, Claude Cowork and Codex (ChatGPT) to FChat: Fan Page and Zalo conversations, customers, orders, reports and chatbot automation. Sign in with your FChat account over OAuth; no token copying needed.

> Sign-in uses your FChat email and password. If you have only ever signed in with Facebook, set a password in FChat (Account → Password) first.

## Quick install (Claude Code)

Open a terminal and paste one command. The script installs Claude Code if missing, updates it if too old, installs the plugin, then opens the FChat sign-in page.

macOS / Linux:

```
curl -fsSL https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install.sh | sh
```

Windows (PowerShell):

```
irm https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install.ps1 | iex
```

## Manual install (Claude Code)

```
claude plugin marketplace add partner-salemall/fchat_mcp_plugin
claude plugin install fchat@fchat
```

## Sign in (Claude Code)

```
claude mcp login plugin:fchat:fchat
```

The browser opens the FChat sign-in page. Sign in, choose your shop and click **Cho phép truy cập** (Allow). The terminal prints `Authenticated with "plugin:fchat:fchat"` when done.

Alternatively: in Claude Code type `/mcp`, select `fchat`, then choose **Authenticate**.

After signing in, open a **new session** and ask, for example:

- "Dùng FChat báo cáo hội thoại 7 ngày qua"
- "Hội thoại nào chưa được trả lời hôm nay?"
- "Tìm khách hàng số 0912345678 trên FChat"

Agent-readable install guide: [docs/claude-install.md](docs/claude-install.md).

## Codex (ChatGPT)

Quick install: open a terminal and paste one command. The script installs the Codex CLI if missing (with npm, or Homebrew on macOS; on Windows it installs Node.js with winget when needed), updates it if too old, installs the plugin, then opens the FChat sign-in page.

macOS / Linux:

```
curl -fsSL https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install-codex.sh | sh
```

Windows (PowerShell):

```
irm https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install-codex.ps1 | iex
```

Manual install:

```
codex plugin marketplace add https://github.com/partner-salemall/fchat_mcp_plugin.git --ref main
codex plugin add fchat@fchat
codex mcp login fchat
```

In the Codex desktop app, use the Codex CLI bundled with the app. Open a **new thread** after signing in. Agent-readable install guide: [docs/codex-install.md](docs/codex-install.md).

Update: `codex plugin marketplace upgrade fchat`.

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

The plugin is read-only for now: it reads data and drafts replies, but does not send messages or change anything in FChat.

## Update (Claude Code)

```
claude plugin marketplace update fchat
claude plugin update fchat@fchat
```

## Uninstall (Claude Code)

```
claude plugin uninstall fchat@fchat
```

To switch shops, sign in again (`claude mcp login plugin:fchat:fchat`) and choose another shop.

## Repository layout

```
.claude-plugin/marketplace.json      Claude Code marketplace
.agents/plugins/marketplace.json     Codex marketplace
plugins/fchat-claude/                Claude Code plugin
  .claude-plugin/plugin.json
  .mcp.json                          Points to https://api.fchat.vn/mcp
  skills/                            Source of truth for every skill
  scripts/login-fchat.sh|.ps1        Sign-in scripts
plugins/fchat-codex/                 Codex plugin
  .codex-plugin/plugin.json
  .mcp.json
  skills/fchat-basics/               Codex edition of the basics skill
  skills/*                           Copied from plugins/fchat-claude/skills
scripts/sync-skills.mjs              Syncs skills into Codex (--check to verify)
docs/claude-install.md               Claude Code install guide for agents
docs/codex-install.md                Codex install guide for agents
```

## Developing skills

1. Edit or add skills in `plugins/fchat-claude/skills/<name>/SKILL.md`. Skills use short tool names (`get_pages`), never a host-specific namespace.
2. Host-specific parts (sign-in, tool namespace) live only in `fchat-basics`, one edition per plugin.
3. Run `node scripts/sync-skills.mjs` to copy them into Codex. CI runs `--check` and fails if the two copies drift.
4. Bump `version` in both plugins' `plugin.json` and in `.claude-plugin/marketplace.json`.
5. When tools are added to or removed from the FChat MCP server (`fchat.vn-node-app/mcp/tools`), update the skills that mention them.
