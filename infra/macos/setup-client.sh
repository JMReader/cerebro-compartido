#!/usr/bin/env bash
set -euo pipefail
if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <participant-id> <repo-url-privada> [brain-root]" >&2
  echo "Ejemplo: $0 participant-2 https://github.com/mi-org/mi-brain.git" >&2
  echo "Opcional: HACKATHON=nombre HACKATHON_ENDS=YYYY-MM-DD $0 ..." >&2
  exit 2
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
PARTICIPANT_ID="$1"
REPO_URL="$2"
BRAIN_ROOT="${3:-$HOME/SharedBrain}"

if [[ ! "$PARTICIPANT_ID" =~ ^[a-z0-9-]+$ ]]; then
  echo "participant-id invalido" >&2
  exit 2
fi

install_apps
gh auth status >/dev/null 2>&1 || { echo "Ejecuta gh auth login con la cuenta invitada al repositorio." >&2; exit 2; }
if [ ! -e "$BRAIN_ROOT" ]; then
  git clone "$REPO_URL" "$BRAIN_ROOT"
elif [ ! -d "$BRAIN_ROOT/.git" ]; then
  echo "$BRAIN_ROOT existe pero no es un repositorio." >&2
  exit 2
else
  git -C "$BRAIN_ROOT" pull --rebase origin main
fi
if [ ! -d "$BRAIN_ROOT/each_one/$PARTICIPANT_ID" ] && [ -d "$BRAIN_ROOT/each_one/${PARTICIPANT_ID/participante-/participant-}" ]; then
  PARTICIPANT_ID="${PARTICIPANT_ID/participante-/participant-}"
fi
set_brain_env "$BRAIN_ROOT" "$PARTICIPANT_ID"
[ -d "$BRAIN_ROOT/each_one/$PARTICIPANT_ID" ] || { echo "Participante inexistente: $PARTICIPANT_ID" >&2; exit 2; }
bash "$SCRIPT_DIR/install-skills.sh" "$BRAIN_ROOT"

echo "CLIENTE GIT PREPARADO. Abre BRAIN_ROOT en Obsidian y ejecuta team/tools/sync-brain.sh al empezar y terminar."
echo "Para sincronizar cada minuto durante el hackaton: bash $SCRIPT_DIR/install-autosync.sh"
