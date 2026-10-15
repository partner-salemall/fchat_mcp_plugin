# fchat plugin for Codex

Connects Codex to the FChat MCP server at `https://api.fchat.vn/mcp` (streamable HTTP, OAuth 2.1 + PKCE). Sign in with `codex mcp login fchat`.

- `.codex-plugin/plugin.json`: plugin metadata and Codex UI details.
- `.mcp.json`: MCP server configuration.
- `skills/fchat-basics/`: the basics skill, written for Codex.
- All other skills are copied from `plugins/fchat-claude/skills/` by `node scripts/sync-skills.mjs`. Do not edit them here; edit the source in the Claude plugin and rerun the script.

Install: see [docs/codex-install.md](../../docs/codex-install.md).
