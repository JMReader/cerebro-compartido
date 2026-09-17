#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
REPO_URL="${1:-}"
PARTICIPANT_ID="${2:-admin}"
BRAIN_ROOT="${3:-$HOME/SharedBrain}"
TEMPLATE_DIR="$(cd "$SCRIPT_DIR/../../vault-template" && pwd)"

if [ -z "$REPO_URL" ]; then
  echo "Uso: $0 <repo-url-privada> [participant-id] [brain-root]" >&2
  echo "Ejemplo: $0 https://github.com/mi-org/mi-brain.git" >&2
  exit 2
fi

install_apps
copy_new_only "$TEMPLATE_DIR" "$BRAIN_ROOT"
copy_new_only "$SCRIPT_DIR/../../skills" "$BRAIN_ROOT/team/skills"
set_brain_env "$BRAIN_ROOT" "$PARTICIPANT_ID"

if [ ! -d "$BRAIN_ROOT/.git" ]; then
  git -C "$BRAIN_ROOT" init -b main
  git -C "$BRAIN_ROOT" add .
  git -C "$BRAIN_ROOT" commit -m "Initialize Shared Brain"
fi
git -C "$BRAIN_ROOT" branch -M main
git -C "$BRAIN_ROOT" remote get-url origin >/dev/null 2>&1 || git -C "$BRAIN_ROOT" remote add origin "$REPO_URL"
bash "$SCRIPT_DIR/install-skills.sh" "$BRAIN_ROOT"

echo "HUB GIT PREPARADO. Ejecuta gh auth login, publica con team/tools/sync-brain.sh, agrega los Collaborators y abre el vault en Obsidian."
