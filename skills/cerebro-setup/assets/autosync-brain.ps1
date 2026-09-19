param(
    [string]$BrainRoot = $(if ($env:BRAIN_ROOT) { $env:BRAIN_ROOT } else { Join-Path $env:USERPROFILE 'SharedBrain' }),
    [string]$HackathonEnds = $env:HACKATHON_ENDS
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($HackathonEnds) {
    try {
        $end = [datetime]::Parse($HackathonEnds).Date
    } catch {
        $end = $null
    }
    if ($end -and (Get-Date).Date -gt $end) {
        Unregister-ScheduledTask -TaskName 'SharedBrainSync' -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "El hackaton termino ($HackathonEnds): autosync desinstalado."
        exit 0
    }
}

& (Join-Path $BrainRoot 'team\tools\sync-brain.ps1')
