param(
    [string]$BrainRoot = $(if ($env:BRAIN_ROOT) { $env:BRAIN_ROOT } else { Join-Path $env:USERPROFILE 'SharedBrain' })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script = Join-Path $BrainRoot 'team\tools\sync-brain.ps1'
if (-not (Test-Path -LiteralPath $script)) { throw "No se encontro sync-brain.ps1 en $BrainRoot" }

$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)

Register-ScheduledTask -TaskName 'SharedBrainSync' -Action $action -Trigger $trigger -Force | Out-Null
Write-Host 'Autosync instalado: sync-brain.ps1 cada minuto.'
Write-Host 'Para quitarlo al terminar el hackaton: infra\windows\uninstall-autosync.ps1'
