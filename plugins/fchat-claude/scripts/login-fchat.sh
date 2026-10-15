#!/bin/sh
# Sign in to FChat for the plugin (macOS / Linux / WSL).
# Opens the browser on the FChat OAuth sign-in page.
# Requires a Claude Code version with `claude mcp login`.

if ! command -v claude >/dev/null 2>&1; then
  echo "The 'claude' command was not found. Install Claude Code first: https://claude.ai/install.sh"
  exit 1
fi

LOGIN="claude mcp login plugin:fchat:fchat"

# `claude mcp login` needs a real terminal (TTY). When run in the background, open a Terminal
# window (macOS) or wrap it in a pseudo-terminal.
if [ -t 0 ]; then
  $LOGIN
elif [ "$(uname -s)" = "Darwin" ]; then
  osascript -e "tell application \"Terminal\" to do script \"$LOGIN\"" -e 'tell application "Terminal" to activate'
  echo "Opened a Terminal window to sign in to FChat. Finish in the browser, then close that window."
elif command -v python3 >/dev/null 2>&1; then
  python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' $LOGIN
else
  script -qc "$LOGIN" /dev/null
fi
