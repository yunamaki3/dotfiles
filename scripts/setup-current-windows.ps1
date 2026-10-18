[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidatePattern('^[a-zA-Z0-9._-]+$')][string]$Distro = 'Ubuntu',
    [string]$TargetHome = $env:USERPROFILE,
    [switch]$InstallFonts
)
$ErrorActionPreference = 'Stop'
$RepoDir = Split-Path -Parent $PSScriptRoot
$Source = Join-Path $RepoDir 'profiles\windows-wsl\wezterm'
$TargetHome = [IO.Path]::GetFullPath($TargetHome)
$Target = Join-Path $TargetHome '.config\wezterm'
$Stamp = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)
$Backup = Join-Path $TargetHome ".dotfiles-backup\$Stamp"

# A top-level config takes precedence over .config/wezterm on Windows.
$Conflicts = @((Join-Path $TargetHome '.wezterm.lua'), $Target)
foreach ($Path in $Conflicts) {
    $Full = [IO.Path]::GetFullPath($Path)
    if (-not $Full.StartsWith($TargetHome.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw "Target is outside TargetHome: $Full"
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $Source 'wezterm.lua'))) { throw 'Missing source config.' }
if ($env:WEZTERM_CONFIG_FILE -or $env:WEZTERM_CONFIG_DIR -or $env:XDG_CONFIG_HOME) {
    Write-Warning 'Custom config environment variables detected; ensure WezTerm loads the installed file.'
}
if ($PSCmdlet.ShouldProcess($Target, 'Back up existing configs and install current Windows/WSL profile')) {
    if ($InstallFonts) {
        & (Join-Path $PSScriptRoot 'install-current-fonts.ps1') -TargetHome $TargetHome
    }
    New-Item -ItemType Directory -Path $Backup -Force | Out-Null
    foreach ($Path in $Conflicts) {
        if (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue) {
            Move-Item -LiteralPath $Path -Destination (Join-Path $Backup (Split-Path -Leaf $Path))
        }
    }
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $Source 'wezterm.lua'), (Join-Path $Source 'keybinds.lua') -Destination $Target
    $Utf8 = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllText((Join-Path $Target 'local.lua'), "return { distro = '$Distro' }`n", $Utf8)
    Write-Host "Installed: $Target"
    Write-Host "Previous configs: $Backup"
    Write-Host 'Install FiraMono Nerd Font and HackGen Console NF on Windows, then run scripts/setup-current-wsl.sh in WSL.'
    Write-Host 'This installation copies files. After git pull, rerun this script to apply updates.'
}
