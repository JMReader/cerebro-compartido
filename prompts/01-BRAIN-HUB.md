# Prompt — computadora administradora

Configura esta computadora como administradora del cerebro compartido usando el kit de esta carpeta.

Objetivo:

- Crear un repositorio privado vacío en GitHub para el equipo (ej. `gh repo create <org>/<repo> --private`) y usarlo como cerebro.
- Instalar o verificar Git, GitHub CLI y Obsidian.
- Ejecutar `infra/macos/setup-hub.sh <repo-url>` en macOS o `infra/windows/setup-hub.ps1 -RepoUrl <repo-url>` en Windows.
- Antes de publicar, editar `.brain/participants.yaml` con un id por integrante y crear su carpeta `each_one/<id>/`.
- Si GitHub CLI todavía no está autorizado, detenerte y pedirme ejecutar `gh auth login`.
- Verificar que `~/SharedBrain` (macOS) o `%USERPROFILE%\SharedBrain` (Windows) tenga el remoto `origin` y la rama `main`.
- Instalar la skill `cerebro-compartido` incluida en el vault.
- Abrir el vault en Obsidian.
- Hacer una sincronización completa con `team/tools/sync-brain.sh` o `team\tools\sync-brain.ps1`.
- Comprobar que el repositorio sea privado y que no haya secretos versionados.

No instales Tailscale ni Syncthing. No uses `git push --force`, `git reset --hard` ni borres contenido de otros participantes. Si aparece un conflicto de Git, detenete, conserva ambas versiones y explícame qué archivos requieren resolución.

Al terminar, informa el estado del repositorio, la ruta local, la skill instalada y los nombres de usuario de GitHub que haya que invitar como colaboradores.
