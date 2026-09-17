Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Unregister-ScheduledTask -TaskName 'SharedBrainSync' -Confirm:$false -ErrorAction SilentlyContinue
Write-Host 'Autosync desinstalado. El vault local y el repositorio quedan intactos.'
