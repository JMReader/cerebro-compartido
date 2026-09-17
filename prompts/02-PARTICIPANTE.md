# Prompt — participante

Configura esta computadora como `<participant-id>` del cerebro compartido usando el kit de esta carpeta.

El repositorio privado es `<repo-url>`. Instala o verifica Git, GitHub CLI y Obsidian. Si GitHub CLI no está autorizado, pedime ejecutar `gh auth login` y continúa después. Ejecuta `infra/macos/setup-client.sh <participant-id> <repo-url>` en macOS o `infra/windows/setup-client.ps1 -ParticipantId <participant-id> -RepoUrl <repo-url>` en Windows. El script debe clonar el cerebro, instalar la skill `cerebro-compartido` y dejar el vault listo para Obsidian.

Después abre el vault, ejecuta `team/tools/sync-brain.sh` o `team\tools\sync-brain.ps1`, crea una nota de prueba dentro de `each_one/<participant-id>/inbox/`, sincronízala y verifica que llegó a GitHub. Luego elimina únicamente esa nota de prueba y vuelve a sincronizar.

Si el hackatón dura poco tiempo, ejecuta `infra/<os>/install-autosync` para sincronizar cada minuto y `uninstall-autosync` para quitarlo al final.

No instales Tailscale ni Syncthing. No uses force push ni modifiques las carpetas privadas de otros participantes. Si Git informa un conflicto, detenete y explícame exactamente qué archivos requieren resolución. Al terminar, informa ruta local, estado de Git y skill instalada.
