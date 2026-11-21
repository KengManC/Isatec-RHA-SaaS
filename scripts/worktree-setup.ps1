# Setup script for Claude Code worktree sessions.
# Copies git-ignored local settings (credentials) from the main checkout
# and installs npm packages for any apps.
$ErrorActionPreference = "Continue"

$main = Split-Path (git rev-parse --path-format=absolute --git-common-dir)
if ($main -and ((Resolve-Path .).Path -ne $main)) {
  New-Item -ItemType Directory -Force .claude | Out-Null
  if (Test-Path "$main\.claude\settings.local.json") {
    Copy-Item "$main\.claude\settings.local.json" .claude\ -Force
  }
}

Get-ChildItem apps -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  if (Test-Path (Join-Path $_.FullName "package.json")) {
    Push-Location $_.FullName
    npm install --silent
    Pop-Location
  }
}
