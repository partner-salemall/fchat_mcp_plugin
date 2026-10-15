# Install the FChat plugin for Claude Code (Windows PowerShell).
# Usage: irm https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install.ps1 | iex

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$repo = 'partner-salemall/fchat_mcp_plugin'
$server = 'plugin:fchat:fchat'

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host 'Claude Code not found. Installing...'
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Write-Host 'Installed, but the claude command is not on PATH yet. Open a new PowerShell window and rerun the FChat install command.'
        return
    }
}

# `claude mcp login` needs a recent Claude Code.
claude mcp login --help *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Claude Code is too old, updating...'
    claude update
    claude mcp login --help *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Could not update Claude Code. If installed with npm, run: npm install -g @anthropic-ai/claude-code@latest'
        return
    }
}

function Stop-Install($message) {
    Write-Host ''
    Write-Host $message -ForegroundColor Red
    Write-Host 'Check your network connection and run the install command again.'
    Write-Host 'If it keeps failing, run the steps by hand: https://github.com/partner-salemall/fchat_mcp_plugin#manual-install-claude-code'
}

# Update the marketplace if it is already registered, otherwise add it (one retry: the clone can time out).
$marketplaces = (claude plugin marketplace list 2>$null) -join "`n"
if ($marketplaces -match '(?m)[ \t]fchat[ \t]*$') {
    Write-Host 'Updating the FChat marketplace...'
    claude plugin marketplace update fchat
} else {
    Write-Host 'Adding the FChat marketplace...'
    claude plugin marketplace add $repo
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Retrying...'
        claude plugin marketplace add $repo
    }
}
if ($LASTEXITCODE -ne 0) { Stop-Install 'Could not add the FChat marketplace.'; return }

Write-Host 'Installing the plugin...'
claude plugin install fchat@fchat
if ($LASTEXITCODE -ne 0) { Stop-Install 'Could not install the FChat plugin.'; return }

# A manually added `fchat` server pointing at the same endpoint duplicates the plugin's tools.
# Remove it only in that case; leave servers pointing anywhere else alone.
$existing = claude mcp get fchat 2>$null
if ($LASTEXITCODE -eq 0) {
    $oldUrl = $null
    $match = $existing | Select-String '^\s*URL:\s*(\S+)' | Select-Object -First 1
    if ($match) { $oldUrl = $match.Matches[0].Groups[1].Value }
    if ($oldUrl -eq 'https://api.fchat.vn/mcp') {
        claude mcp remove fchat *> $null
        Write-Host "Removed the old manually added 'fchat' server (duplicate of the plugin)."
    } else {
        if (-not $oldUrl) { $oldUrl = 'not an HTTP server' }
        Write-Host "Note: you have a separate MCP server named 'fchat' ($oldUrl). It was left unchanged."
        Write-Host 'If you no longer need it, remove it with: claude mcp remove fchat'
    }
}

Write-Host ''
Write-Host 'Opening the FChat sign-in page. Sign in, choose your shop, then click "Cho phép truy cập" (Allow).'
claude mcp login $server
if ($LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host 'The plugin is installed, but sign-in did not finish.' -ForegroundColor Yellow
    Write-Host "Run this to sign in again: claude mcp login $server"
    return
}

Write-Host ''
Write-Host 'Done. Open Claude Code (command: claude) and try: "Dùng FChat báo cáo hội thoại 7 ngày qua"'
