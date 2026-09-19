#!/usr/bin/env bash
set -euo pipefail
( crontab -l 2>/dev/null | grep -v 'autosync-brain.sh' || true ) | crontab -
echo "Autosync desinstalado. El vault local y el repositorio quedan intactos."
