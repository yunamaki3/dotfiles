$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $PSScriptRoot
$ConfigDir = Join-Path $env:USERPROFILE ".config"
$WezTarget = Join-Path $ConfigDir "wezterm"
$WezSource = Join-Path $RepoDir ".config\wezterm"
$BackupDir = Join-Path $env:USERPROFILE (".dotfiles-backup\" + (Get-Date -Format "yyyyMMdd-HHmmss"))

New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
if ((Test-Path $WezTarget) -and -not ((Get-Item $WezTarget).LinkType)) {
  New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
  Move-Item $WezTarget (Join-Path $BackupDir "wezterm")
}
if (Test-Path $WezTarget) {
  Remove-Item $WezTarget
}
New-Item -ItemType Junction -Path $WezTarget -Target $WezSource | Out-Null

Write-Host "WezTerm config linked. Install these fonts on Windows:"
Write-Host "  FiraMono Nerd Font Mono"
Write-Host "  Noto Sans Mono CJK JP"
Write-Host "Then run scripts/setup-wsl.sh inside WSL."

