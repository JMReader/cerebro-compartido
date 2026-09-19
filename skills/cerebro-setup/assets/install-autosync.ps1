param(
    [string]$BrainRoot = $(if ($env:BRAIN_ROOT) { $env:BRAIN_ROOT } else { Join-Path $env:USERPROFILE 'SharedBrain' }),
    [int]$Minutes = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$wrapper = Join-Path $PSScriptRoot 'autosync-brain.ps1'
$script = Join-Path $BrainRoot 'team\tools\sync-brain.ps1'
if (-not (Test-Path -LiteralPath $script)) { throw "No se encontro sync-brain.ps1 en $BrainRoot" }
if ($Minutes -lt 1 -or $Minutes -gt 1440) { throw "Intervalo invalido: $Minutes minutos." }

$hackathonEnds = ''
if ($env:HACKATHON_ENDS) { $hackathonEnds = $env:HACKATHON_ENDS }

$arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$wrapper`" -BrainRoot `"$BrainRoot`""
if ($hackathonEnds) { $arguments += " -HackathonEnds `"$hackathonEnds`"" }

$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arguments
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Minutes)

Register-ScheduledTask -TaskName 'SharedBrainSync' -Action $action -Trigger $trigger -Force | Out-Null
Write-Host "Autosync instalado: sync cada $Minutes minutos."
Write-Host "Se desinstala solo cuando pasa HACKATHON_ENDS='$hackathonEnds'. Manual: uninstall-autosync.ps1"
