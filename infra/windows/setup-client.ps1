param(
    [Parameter(Mandatory = $true)][ValidatePattern('^[a-z0-9-]+$')][string]$ParticipantId,
    [Parameter(Mandatory = $true)][string]$RepoUrl,
    [string]$BrainRoot = (Join-Path $env:USERPROFILE 'SharedBrain')
)

. (Join-Path $PSScriptRoot 'common.ps1')

Install-BrainPackage -Id 'Git.Git' -Label 'Git'
Install-BrainPackage -Id 'GitHub.cli' -Label 'GitHub CLI'
Install-BrainPackage -Id 'Obsidian.Obsidian' -Label 'Obsidian'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI no esta disponible. Abrir un shell nuevo y reintentar.' }
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) { throw 'Falta ejecutar gh auth login con la cuenta invitada al repositorio.' }

if (-not (Test-Path -LiteralPath $BrainRoot)) {
    git clone $RepoUrl $BrainRoot
} elseif (-not (Test-Path -LiteralPath (Join-Path $BrainRoot '.git'))) {
    throw "$BrainRoot ya existe pero no es un repositorio. Elegir otra ruta o moverlo manualmente."
} else {
    git -C $BrainRoot pull --rebase origin main
}

Set-BrainEnvironment -BrainRoot $BrainRoot -ParticipantId $ParticipantId
if (-not (Test-Path -LiteralPath (Join-Path $BrainRoot "each_one\$ParticipantId"))) {
    throw "El participante $ParticipantId no existe en el cerebro."
}
& (Join-Path $PSScriptRoot 'install-skills.ps1') -BrainRoot $BrainRoot

Write-Host ''
Write-Host 'CLIENTE GIT PREPARADO.'
Write-Host '1) Abrir BRAIN_ROOT como vault de Obsidian.'
Write-Host '2) Al empezar y terminar, ejecutar team\tools\sync-brain.ps1.'
Write-Host "3) Escribir por defecto en each_one\$ParticipantId."
Write-Host '4) Para sincronizar cada minuto durante el hackaton: infra\windows\install-autosync.ps1'
