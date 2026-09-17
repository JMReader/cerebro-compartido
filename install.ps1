# Instala la skill cerebro-compartido directamente desde este repo a los
# directorios de skills de los agentes instalados. No requiere un cerebro.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceRoot = Join-Path $PSScriptRoot 'skills'
$destRoots = @(
    (Join-Path $env:USERPROFILE '.codex\skills'),
    (Join-Path $env:USERPROFILE '.claude\skills'),
    (Join-Path $env:USERPROFILE '.agents\skills')
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

Write-Host 'Skill instalada. Para crear un cerebro nuevo segui el Quickstart del README.'
