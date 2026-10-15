#!/bin/sh
# Install the FChat plugin for Codex (ChatGPT) (macOS / Linux / WSL).
# Usage: curl -fsSL https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install-codex.sh | sh

set -e

REPO_URL="https://github.com/partner-salemall/fchat_mcp_plugin.git"
SERVER="fchat"

# Install (or update) the Codex CLI with npm, falling back to Homebrew.
install_codex() {
  if command -v npm >/dev/null 2>&1; then
    if npm install -g @openai/codex@latest; then
      # npm's global bin directory may not be on PATH yet.
      NPM_BIN="$(npm prefix -g 2>/dev/null)/bin"
      command -v codex >/dev/null 2>&1 || export PATH="$NPM_BIN:$PATH"
      return 0
    fi
    echo "npm could not install the Codex CLI. If it failed with a permission error (EACCES), run:"
    echo "  sudo npm install -g @openai/codex@latest"
    echo "then run the FChat install command again."
    return 1
  fi
  if command -v brew >/dev/null 2>&1; then
    if command -v codex >/dev/null 2>&1; then
      brew upgrade --cask codex
    else
      brew install --cask codex
    fi
    return $?
  fi
  echo "Could not install the Codex CLI automatically: neither npm nor Homebrew was found."
  echo "Install Node.js (https://nodejs.org), then run the FChat install command again."
  return 1
}

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI not found. Installing..."
  install_codex || exit 1
  if ! command -v codex >/dev/null 2>&1; then
    echo "Installed, but the codex command is not on PATH yet. Open a new terminal and run the FChat install command again."
    exit 1
  fi
fi

# `codex plugin` needs a recent Codex CLI.
if ! codex plugin --help >/dev/null 2>&1; then
  echo "Codex CLI is too old, updating..."
  install_codex || exit 1
  if ! codex plugin --help >/dev/null 2>&1; then
    echo "Could not update the Codex CLI. Run: npm install -g @openai/codex@latest    (or: brew upgrade --cask codex)"
    exit 1
  fi
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git not found. Codex needs git to download the FChat marketplace."
  echo "Install git (macOS: xcode-select --install), then run the FChat install command again."
  exit 1
fi

fail() {
  echo ""
  echo "$1"
  echo "Check your network connection and run the install command again."
  echo "If it keeps failing, run the steps by hand: https://github.com/partner-salemall/fchat_mcp_plugin#codex-chatgpt"
  exit 1
}

# Upgrade the marketplace if it is already registered, otherwise add it (one retry: the clone can time out).
if codex plugin marketplace upgrade fchat >/dev/null 2>&1; then
  echo "Updated the FChat marketplace."
else
  echo "Adding the FChat marketplace..."
  codex plugin marketplace add "$REPO_URL" --ref main ||
    { echo "Retrying..."; codex plugin marketplace add "$REPO_URL" --ref main; } ||
    fail "Could not add the FChat marketplace."
fi

echo "Installing the plugin..."
codex plugin add fchat@fchat || fail "Could not install the FChat plugin."

echo ""
echo "Opening the FChat sign-in page. Sign in, choose your shop, then click \"Cho phép truy cập\" (Allow)."
# Under `curl | sh`, stdin is a pipe; reattach the keyboard from the terminal.
# Use the real device (e.g. /dev/ttys003) rather than /dev/tty, which kqueue on macOS does not support.
TTY_DEV=""
if [ ! -t 0 ]; then
  T=$(ps -o tty= -p $$ 2>/dev/null | tr -d ' ')
  case "$T" in
    ""|"?"|"??") ;;
    *) [ -r "/dev/$T" ] && TTY_DEV="/dev/$T" ;;
  esac
  if [ -z "$TTY_DEV" ] && [ "$(uname -s)" != "Darwin" ] && [ -r /dev/tty ]; then
    TTY_DEV="/dev/tty"
  fi
fi
LOGIN_OK=0
if [ -n "$TTY_DEV" ]; then
  codex mcp login "$SERVER" < "$TTY_DEV" || LOGIN_OK=1
elif [ -t 0 ]; then
  codex mcp login "$SERVER" || LOGIN_OK=1
else
  # No terminal at all: keep codex from swallowing the rest of the piped script.
  codex mcp login "$SERVER" < /dev/null || LOGIN_OK=1
fi
if [ "$LOGIN_OK" -ne 0 ]; then
  echo ""
  echo "The plugin is installed, but sign-in did not finish."
  echo "Run this to sign in again: codex mcp login $SERVER"
  exit 1
fi

echo ""
echo "Done. Open a NEW thread in Codex and try: \"Dùng FChat báo cáo hội thoại 7 ngày qua\""
