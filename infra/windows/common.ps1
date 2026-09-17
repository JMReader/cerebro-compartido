Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Install-BrainPackage {
    param([string]$Id, [string]$Label)
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warning "winget no esta disponible. Instala manualmente: $Label"
        return
    }
    $installed = winget list --id $Id --exact --accept-source-agreements 2>$null
    if ($LASTEXITCODE -eq 0 -and ($installed -join "`n") -match [regex]::Escape($Id)) {
        Write-Host "OK: $Label ya esta instalado."
        return
    }
    Write-Host "Instalando $Label..."
    winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { Write-Warning "No se pudo instalar $Label automaticamente." }
}

function Copy-BrainTemplateNewOnly {
    param([string]$Source, [string]$Destination)
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    Get-ChildItem -LiteralPath $Source -Recurse -Force | ForEach-Object {
        $relative = $_.FullName.Substring($Source.Length).TrimStart('\')
        $target = Join-Path $Destination $relative
        if ($_.PSIsContainer) {
            New-Item -ItemType Directory -Force -Path $target | Out-Null
        } elseif (-not (Test-Path -LiteralPath $target)) {
            $parent = Split-Path -Parent $target
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
            Copy-Item -LiteralPath $_.FullName -Destination $target
        }
    }
}

function Set-BrainEnvironment {
    param([string]$BrainRoot, [string]$ParticipantId)
    [Environment]::SetEnvironmentVariable('BRAIN_ROOT', $BrainRoot, 'User')
    [Environment]::SetEnvironmentVariable('PARTICIPANT_ID', $ParticipantId, 'User')
    $env:BRAIN_ROOT = $BrainRoot
    $env:PARTICIPANT_ID = $ParticipantId
    if ($env:HACKATHON) { [Environment]::SetEnvironmentVariable('HACKATHON', $env:HACKATHON, 'User') }
    if ($env:HACKATHON_ENDS) { [Environment]::SetEnvironmentVariable('HACKATHON_ENDS', $env:HACKATHON_ENDS, 'User') }
    Write-Host "BRAIN_ROOT=$BrainRoot"
    Write-Host "PARTICIPANT_ID=$ParticipantId"
}
