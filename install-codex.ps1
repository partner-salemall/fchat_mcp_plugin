# Install the FChat plugin for Codex (ChatGPT) (Windows PowerShell).
# Usage: irm https://raw.githubusercontent.com/partner-salemall/fchat_mcp_plugin/main/install-codex.ps1 | iex

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$repoUrl = 'https://github.com/partner-salemall/fchat_mcp_plugin.git'
$server = 'fchat'

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user;$env:Path"
}

# Install (or update) the Codex CLI with npm, installing Node.js with winget first if needed.
function Install-Codex {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Host 'Could not install the Codex CLI automatically: neither npm nor winget was found.'
            Write-Host 'Install Node.js (https://nodejs.org), then open a new PowerShell window and run the FChat install command again.'
            return $false
        }
        Write-Host 'Node.js not found. Installing Node.js LTS...'
        winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements | Out-Host
        Update-SessionPath
        if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
            Write-Host 'Node.js was installed, but npm is not on PATH yet. Open a new PowerShell window and run the FChat install command again.'
            return $false
        }
    }
    npm install -g '@openai/codex@latest' | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'npm could not install the Codex CLI. Run: npm install -g @openai/codex@latest'
        return $false
    }
    # npm's global directory may not be on PATH yet.
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
        $npmPrefix = (npm prefix -g 2>$null | Select-Object -First 1)
        if ($npmPrefix) { $env:Path = "$npmPrefix;$env:Path" }
    }
    return $true
}

if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host 'Codex CLI not found. Installing...'
    if (-not (Install-Codex)) { return }
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
        Write-Host 'Installed, but the codex command is not on PATH yet. Open a new PowerShell window and run the FChat install command again.'
        return
    }
}

# `codex plugin` needs a recent Codex CLI.
codex plugin --help *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Codex CLI is too old, updating...'
    if (-not (Install-Codex)) { return }
    codex plugin --help *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Could not update the Codex CLI. Run: npm install -g @openai/codex@latest'
        return
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host 'git not found. Codex needs git to download the FChat marketplace.'
    Write-Host 'Install git (https://git-scm.com/download/win or: winget install Git.Git), then run the FChat install command again.'
    return
}

function Stop-Install($message) {
    Write-Host ''
    Write-Host $message -ForegroundColor Red
    Write-Host 'Check your network connection and run the install command again.'
    Write-Host 'If it keeps failing, run the steps by hand: https://github.com/partner-salemall/fchat_mcp_plugin#codex-chatgpt'
}

# Upgrade the marketplace if it is already registered, otherwise add it (one retry: the clone can time out).
codex plugin marketplace upgrade fchat *> $null
if ($LASTEXITCODE -eq 0) {
    Write-Host 'Updated the FChat marketplace.'
} else {
    Write-Host 'Adding the FChat marketplace...'
    codex plugin marketplace add $repoUrl --ref main
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Retrying...'
        codex plugin marketplace add $repoUrl --ref main
    }
    if ($LASTEXITCODE -ne 0) { Stop-Install 'Could not add the FChat marketplace.'; return }
}

Write-Host 'Installing the plugin...'
codex plugin add fchat@fchat
if ($LASTEXITCODE -ne 0) { Stop-Install 'Could not install the FChat plugin.'; return }

Write-Host ''
Write-Host 'Opening the FChat sign-in page. Sign in, choose your shop, then click "Cho phép truy cập" (Allow).'
codex mcp login $server
if ($LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host 'The plugin is installed, but sign-in did not finish.' -ForegroundColor Yellow
    Write-Host "Run this to sign in again: codex mcp login $server"
    return
}

Write-Host ''
Write-Host 'Done. Open a NEW thread in Codex and try: "Dùng FChat báo cáo hội thoại 7 ngày qua"'
