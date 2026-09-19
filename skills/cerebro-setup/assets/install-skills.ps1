param(
    [string]$BrainRoot = $(if ($env:BRAIN_ROOT) { $env:BRAIN_ROOT } else { Join-Path $env:USERPROFILE 'SharedBrain' })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$sourceRoot = Join-Path $BrainRoot 'team\skills'
if (-not (Test-Path -LiteralPath $sourceRoot)) {
    throw "Las skills aun no estan sincronizadas en $sourceRoot"
}

$destRoots = @(
    (Join-Path $env:USERPROFILE '.codex\skills'),
    (Join-Path $env:USERPROFILE '.claude\skills')
)
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

foreach ($destRoot in $destRoots) {
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
    Get-ChildItem -LiteralPath $sourceRoot -Directory | ForEach-Object {
        $dest = Join-Path $destRoot $_.Name
        if (Test-Path -LiteralPath $dest) {
            $item = Get-Item -LiteralPath $dest -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                Write-Host "OK: enlace existente $dest"
                return
            }
            $backup = "$dest.backup-$stamp"
            Move-Item -LiteralPath $dest -Destination $backup
            Write-Host "Backup: $backup"
        }
        try {
            New-Item -ItemType Junction -Path $dest -Target $_.FullName | Out-Null
            Write-Host "Enlace: $dest -> $($_.FullName)"
        } catch {
            Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse
            Write-Warning "Se copio $($_.Name); volver a ejecutar despues de actualizaciones."
        }
    }
}
