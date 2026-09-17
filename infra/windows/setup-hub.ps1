param(
    [Parameter(Mandatory = $true)][string]$RepoUrl,
    [string]$ParticipantId = 'admin',
    [string]$BrainRoot = (Join-Path $env:USERPROFILE 'SharedBrain')
)

. (Join-Path $PSScriptRoot 'common.ps1')

$template = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\vault-template'))
if (-not (Test-Path -LiteralPath (Join-Path $template '.brain\brain-config.yaml'))) {
    throw "No se encontro el template del brain en $template"
}

Install-BrainPackage -Id 'Git.Git' -Label 'Git'
Install-BrainPackage -Id 'GitHub.cli' -Label 'GitHub CLI'
Install-BrainPackage -Id 'Obsidian.Obsidian' -Label 'Obsidian'

Copy-BrainTemplateNewOnly -Source $template -Destination $BrainRoot
Set-BrainEnvironment -BrainRoot $BrainRoot -ParticipantId $ParticipantId

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git no esta disponible en este shell. Abrir uno nuevo y reintentar.' }
if (-not (Test-Path -LiteralPath (Join-Path $BrainRoot '.git'))) {
    git -C $BrainRoot init -b main | Out-Null
    git -C $BrainRoot add .
    git -C $BrainRoot commit -m 'Initialize Shared Brain'
}
git -C $BrainRoot branch -M main
if (-not (git -C $BrainRoot remote)) {
    git -C $BrainRoot remote add origin $RepoUrl
}

& (Join-Path $PSScriptRoot 'install-skills.ps1') -BrainRoot $BrainRoot

Write-Host ''
Write-Host 'HUB GIT PREPARADO. Pasos interactivos:'
Write-Host '1) Ejecutar gh auth login si GitHub CLI aun no tiene sesion.'
Write-Host '2) Confirmar que origin apunta al repositorio privado.'
Write-Host '3) Ejecutar team\tools\sync-brain.ps1 para publicar.'
Write-Host '4) Agregar los cuatro usuarios como Collaborators.'
Write-Host '5) Abrir BRAIN_ROOT como vault de Obsidian.'
