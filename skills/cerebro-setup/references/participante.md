# Prompt de onboarding — compañero del equipo

Quien creó el cerebro copia este texto y se lo pega al agente de cada compañero, reemplazando `<repo-del-cerebro>`, `<mi-usuario-github>` y `<mi-alias>`.

---

Configurá esta computadora como participante del cerebro compartido del equipo usando la skill `cerebro-setup`. Si el plugin no está instalado, cloná `https://github.com/JMReader/cerebro-compartido`; los assets necesarios están en `skills/cerebro-setup/assets/`.

El repositorio privado del cerebro es `<repo-del-cerebro>` y mi cuenta de GitHub `<mi-usuario-github>` ya fue invitada como colaboradora.

1. Instalá o verificá Git, GitHub CLI y Obsidian. Si `gh auth status` falla, pedime ejecutar `gh auth login` y seguí después.
2. Cloná el cerebro en `~/SharedBrain` (macOS) o `%USERPROFILE%\SharedBrain` (Windows).
3. Definí `BRAIN_ROOT`, `PARTICIPANT_ID`, `HACKATHON` y `HACKATHON_ENDS` en `~/.cerebro/shared-brain.env` con su línea de `source` en `~/.zshrc` (macOS) o como variables de entorno de usuario (Windows).
4. Si existe `each_one/<mi-usuario-github>` (creada con mi username de GitHub), renombrala a `each_one/<mi-alias>` y actualizá `.brain/participants.yaml` (id y name). Si no existe ninguna carpeta mía, creá `each_one/<mi-alias>/` y mi entrada en `participants.yaml`. Commiteá y sincronizá.
5. Instalá las skills del equipo con `install-skills.sh` (macOS) o `install-skills.ps1` (Windows) desde los assets.
6. Sync de prueba: creá una nota en `each_one/<mi-alias>/inbox/`, ejecutá `team/tools/sync-brain.sh` o `sync-brain.ps1`, verificá que llegó a GitHub, borrala y sincronizá de nuevo.
7. Instalá el autosync con TTL con `install-autosync.sh` / `install-autosync.ps1`: corre cada N minutos durante el hackatón y se desinstala solo cuando pasa `HACKATHON_ENDS`.

No uses `git push --force`, `git reset --hard` ni escribas en las carpetas de otros participantes. Si Git informa un conflicto, detenete, conservá ambas versiones y explicame qué archivos requieren resolución. Al terminar, informame la ruta local, el estado de Git y las skills instaladas.
