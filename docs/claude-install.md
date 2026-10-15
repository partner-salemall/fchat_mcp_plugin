# FChat plugin for Claude Code: install guide (for AI agents)

This guide is written for Claude Code to follow on the user's behalf. Host it as plain text at a stable URL (for example https://fchat.vn/claude) so the user can tell Claude: "Install the FChat plugin from https://fchat.vn/claude".

## 1. Install

Run in order:

```
claude plugin marketplace add partner-salemall/fchat_mcp_plugin
claude plugin install fchat@fchat
```

The marketplace command clones a git repository. Give it a generous timeout and wait for it to exit; do not start a second attempt while one is running.

If a standalone server named exactly `fchat` exists (`claude mcp get fchat`), check its `URL:` line. If it is `https://api.fchat.vn/mcp`, it duplicates the plugin: remove it with `claude mcp remove fchat` and tell the user. If it points anywhere else, leave it alone and mention it to the user. Never remove `plugin:fchat:fchat`.

## 2. Log in

`claude mcp login` needs an interactive terminal. Your shell has none (it fails with "stdin isn't a terminal"), so do not run it directly. Open it in a new terminal window on the user's machine instead, with the command for their OS:

- Windows (works from PowerShell, cmd or Git Bash):
  ```
  powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/k','claude mcp login plugin:fchat:fchat'"
  ```
- macOS:
  ```
  osascript -e 'tell application "Terminal" to do script "claude mcp login plugin:fchat:fchat"' -e 'tell application "Terminal" to activate'
  ```
- Linux / WSL (no window needed, Python provides a pseudo-terminal):
  ```
  python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' claude mcp login plugin:fchat:fchat
  ```

A terminal window and a browser tab with the FChat sign-in page open. Tell the user (in Vietnamese) to sign in, choose their shop, click "Cho phép truy cập", then confirm the new terminal window shows `Authenticated with "plugin:fchat:fchat"` and close that window. Wait for the user to confirm before continuing. Run only one login at a time.

## 3. Verify

```
claude plugin list
claude mcp get plugin:fchat:fchat
```

`fchat@fchat` must be enabled, and `plugin:fchat:fchat` must show `Connected`. `Needs authentication` means the login did not finish: repeat step 2.

## 4. Finish

Tell the user, in Vietnamese, that FChat is ready, that they must open a **new session** for the tools to load, and give one example request such as "Dùng FChat báo cáo hội thoại 7 ngày qua". Do not call FChat tools in the installation session.

## Troubleshooting

- `claude mcp login` not found: Claude Code is too old (needs 2.1.210 or newer; check with `claude --version`). Run `claude update`, or `npm install -g @anthropic-ai/claude-code@latest`, then retry.
- `Authentication timeout`: start one fresh login. Never run two logins at once.
- HTTP 5xx during login: FChat's auth service is temporarily unavailable. Wait and retry; do not reinstall. You can probe `curl -fsS https://api.fchat.vn/.well-known/oauth-protected-resource`.
- Tools return an authentication error in a later session: run step 2 again.
