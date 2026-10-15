# FChat plugin for Codex: install guide (for AI agents)

This guide is written for Codex to follow on the user's behalf. The user can tell Codex: "Install the FChat plugin from https://github.com/partner-salemall/fchat_mcp_plugin/blob/main/docs/codex-install.md".

In the Codex desktop app, use the Codex CLI bundled with the app rather than a separate `codex` from npm or Homebrew, so the plugin lands in the app's own configuration. Below, `codex` means that CLI.

## 1. Install

```
codex --version
codex plugin marketplace add https://github.com/partner-salemall/fchat_mcp_plugin.git --ref main
codex plugin add fchat@fchat
```

The marketplace command clones a git repository. Give it a generous timeout and wait for it to exit. If it fails with a git error such as `program not found`, check `git --version` first. If the marketplace already exists, run `codex plugin marketplace upgrade fchat` instead of adding it again.

Do not open a new thread yet. Finish login and verification first.

## 2. Log in

```
codex mcp login fchat
```

A browser tab opens the FChat sign-in page. Tell the user (in Vietnamese) to sign in, choose their shop, and click "Cho phép truy cập". If the command fails or times out, run it once more. Run only one login at a time.

## 3. Verify

```
codex plugin list --marketplace fchat
codex mcp get fchat
```

`fchat@fchat` must be installed and enabled, and the `fchat` MCP server must be present and authenticated.

## 4. Finish

Tell the user, in Vietnamese, that FChat is ready, that they must open a **new thread** for the tools to load, and give one example request such as "Dùng FChat báo cáo hội thoại 7 ngày qua". Do not call FChat tools in the installation thread.

## Update

```
codex plugin marketplace upgrade fchat
```

## Troubleshooting

- Tools return an authentication error in a later thread: run step 2 again. Reinstalling the plugin does not fix authentication.
- HTTP 5xx during login: FChat's auth service is temporarily unavailable. Wait and retry. You can probe `curl -fsS https://api.fchat.vn/.well-known/oauth-protected-resource/mcp`.
- A manually added server also named `fchat` conflicts with the plugin. Check `codex mcp list`; ask the user before removing a server they added themselves.
