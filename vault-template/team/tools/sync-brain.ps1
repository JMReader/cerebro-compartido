param(
    [string]$BrainRoot = $(if ($env:BRAIN_ROOT) { $env:BRAIN_ROOT } else { Join-Path $env:USERPROFILE 'SharedBrain' }),
    [string]$ParticipantId = $env:PARTICIPANT_ID,
    [string]$Message = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $ParticipantId) { throw 'Falta PARTICIPANT_ID.' }
if (-not (Test-Path -LiteralPath (Join-Path $BrainRoot '.git'))) { throw "No hay repositorio Git en $BrainRoot" }
if (Test-Path -LiteralPath (Join-Path $BrainRoot '.git\rebase-merge')) { throw 'Hay un rebase pendiente. Resolverlo antes de sincronizar.' }

git -C $BrainRoot add -A
git -C $BrainRoot diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    if (-not $Message) { $Message = "brain: $ParticipantId $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" }
    git -C $BrainRoot commit -m $Message
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear el commit.' }
}

git -C $BrainRoot pull --rebase origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Pull/rebase detenido. Resolver los conflictos sin usar reset --hard ni push --force.'
    exit 2
}

for ($attempt = 1; $attempt -le 2; $attempt++) {
    git -C $BrainRoot push origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Shared Brain sincronizado por $ParticipantId."
        exit 0
    }
    if ($attempt -eq 1) {
        git -C $BrainRoot pull --rebase origin main
        if ($LASTEXITCODE -ne 0) {
            Write-Error 'Otro cambio genero un conflicto. Resolverlo manualmente.'
            exit 2
        }
    }
}

throw 'No se pudo publicar despues de dos intentos.'
