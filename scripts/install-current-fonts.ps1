[CmdletBinding(SupportsShouldProcess)]
param([string]$TargetHome = $env:USERPROFILE)
$ErrorActionPreference = 'Stop'
$FontDir = Join-Path $TargetHome '.local\share\dotfiles\fonts'
if (-not $PSCmdlet.ShouldProcess($FontDir, 'Download FiraMono Nerd Font and HackGen NF from official releases')) { return }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Downloads = @{
    FiraMono = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/FiraMono.zip'
    HackGen = 'https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_NF_v2.10.0.zip'
}
$CacheDir = Join-Path $TargetHome ('.cache\dotfiles-fonts\' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $CacheDir,$FontDir -Force | Out-Null
foreach ($Name in $Downloads.Keys) {
    $Zip = Join-Path $CacheDir "$Name.zip"
    $Expanded = Join-Path $CacheDir $Name
    Invoke-WebRequest -UseBasicParsing -Uri $Downloads[$Name] -OutFile $Zip
    Expand-Archive -LiteralPath $Zip -DestinationPath $Expanded
    $Fonts = @(Get-ChildItem -LiteralPath $Expanded -Recurse -File | Where-Object { $_.Extension -in '.ttf','.otf' })
    if ($Fonts.Count -eq 0) { throw "No font files found in $Name" }
    foreach ($Font in $Fonts) { Copy-Item -LiteralPath $Font.FullName -Destination $FontDir -Force }
    # Preserve upstream licenses beside the fonts.
    $LicenseDir = Join-Path $FontDir "$Name-licenses"
    New-Item -ItemType Directory -Path $LicenseDir -Force | Out-Null
    Get-ChildItem -LiteralPath $Expanded -Recurse -File | Where-Object Name -Match 'LICENSE|OFL|COPYING' | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $LicenseDir -Force
    }
}
Write-Host "Fonts installed for WezTerm only: $FontDir"
Write-Host "Downloaded archives retained at: $CacheDir"
