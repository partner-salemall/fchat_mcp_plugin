# Sign in to FChat for the plugin (Windows PowerShell).
# Opens the browser on the FChat OAuth sign-in page.

$claude = (Get-Command claude -ErrorAction SilentlyContinue).Source
if (-not $claude) {
    Write-Host "The 'claude' command was not found. Install Claude Code first: irm https://claude.ai/install.ps1 | iex"
    exit 1
}

# `claude mcp login` needs a real terminal. When run in the background (e.g. from Claude Code), open a new window.
if ([Console]::IsInputRedirected) {
    Start-Process cmd -ArgumentList '/k', 'claude mcp login plugin:fchat:fchat'
    Write-Host 'Opened the FChat sign-in window. Finish in the browser, then close that window.'
} else {
    & $claude mcp login plugin:fchat:fchat
}
