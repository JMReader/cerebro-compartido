---
name: cerebro-setup
description: Configurar el cerebro compartido del equipo en esta máquina (crear el repo privado y el vault si sos el primero, o clonarlo si sos compañero), definir identidad y dejar autosync con TTL. Usar una sola vez por máquina, al sumarse al hackatón.
---

# Setup del cerebro compartido

Corre una vez por máquina. Guiarse por el guion exacto de [references/preguntas.md](references/preguntas.md): hacer una pregunta a la vez y no crear nada hasta saber si la persona es la primera (HUB) o compañera (COMPAÑERO).

## Rama HUB — primera persona

1. Pedir los perfiles de GitHub de todos los compañeros.
2. Crear el repo privado vacío del cerebro e invitar a cada uno:
   ```bash
   gh repo create <org>/<nombre-brain> --private
   gh api --method PUT repos/<org>/<brain>/collaborators/<user> -f permission=push
   ```
3. Copiar `assets/vault-template/` a `~/SharedBrain` (`%USERPROFILE%\SharedBrain` en Windows).
4. Editar `.brain/participants.yaml` con una entrada por compañero usando su **username de GitHub como id provisorio** y crear `each_one/<github-user>/` para cada uno. Completar `sync.remote` en `.brain/brain-config.yaml` con la URL del repo.
5. Copiar las skills `cerebro-leer` y `cerebro-cierre` del plugin a `team/skills/` del cerebro para que `install-skills` las distribuya al equipo.
6. Publicar el cerebro:
   ```bash
   git -C ~/SharedBrain init -b main
   git -C ~/SharedBrain add . && git -C ~/SharedBrain commit -m "Cerebro inicial"
   git -C ~/SharedBrain remote add origin <url-del-repo>
   git -C ~/SharedBrain push -u origin main
   ```
7. Repo del proyecto del hackatón:
   - Si NO existe: pedir nombre, recomendar monolito (front y back en el mismo repo) y pedir tecnologías de back y front → `gh repo create` → scaffold mínimo: README, `AGENTS.md` con el bloque de `assets/agents-snippet.md`, `brain.yaml` copiado desde `assets/brain.yaml`. Usar la skill `find-skills` (si está disponible) para buscar e instalar las skills más relevantes del stack elegido; si no está, crear skills mínimas (`frontend.md`, `backend.md` con comandos build/test). Escribir la **primera nota compartida** en el cerebro (`team/` o una decisión inicial) registrando stack elegido y skills instaladas.
   - Si YA existe: verificar que `AGENTS.md` tenga el bloque `## Cerebro compartido` (agregarlo desde `assets/agents-snippet.md` si falta) y crear `brain.yaml` en la raíz.
8. Definir el ambiente (ver abajo) e instalar autosync con TTL.
9. Sync final con `team/tools/sync-brain.sh` (macOS) o `sync-brain.ps1` (Windows).
10. Entregar a cada compañero el prompt de [references/participante.md](references/participante.md) reemplazando la URL del repo.

## Rama COMPAÑERO

1. Pedir la URL del repo privado del cerebro y clonarlo en `~/SharedBrain` (`%USERPROFILE%\SharedBrain` en Windows).
2. Escribir el env file (ver abajo) e instalar las skills del equipo con `assets/install-skills.sh` (macOS) o `assets/install-skills.ps1` (Windows).
3. Alias: si existe `each_one/<github-user>` (creada por el dueño con el username de GitHub) y la persona se identifica como `<alias>`, renombrar la carpeta a `each_one/<alias>`, actualizar `.brain/participants.yaml` (id y name), commit y sync. Si no existe carpeta alguna para la persona, crear `each_one/<alias>/` y su entrada en `participants.yaml`.
4. Sync de prueba: crear una nota en `each_one/<alias>/inbox/`, ejecutar `team/tools/sync-brain`, verificar que llegó a GitHub, borrarla y sincronizar otra vez.
5. Instalar autosync con TTL.

## Ambiente

macOS: crear `~/.cerebro/shared-brain.env` con `BRAIN_ROOT`, `PARTICIPANT_ID`, `HACKATHON` y `HACKATHON_ENDS` (fecha ISO), y agregar a `~/.zshrc`:

```bash
[ -f "$HOME/.cerebro/shared-brain.env" ] && source "$HOME/.cerebro/shared-brain.env"
```

Windows: definir las mismas variables como variables de entorno de usuario.

## Autosync con TTL

- `assets/autosync-brain.sh` / `autosync-brain.ps1`: wrapper. Si la fecha actual supera `HACKATHON_ENDS` se auto-desinstala (quita su línea de cron o la tarea `SharedBrainSync`) y sale; si no, ejecuta `team/tools/sync-brain`.
- `assets/install-autosync.sh [minutos]` registra en cron `*/N * * * *` la llamada al wrapper con `BRAIN_ROOT`, `PARTICIPANT_ID` y `HACKATHON_ENDS` embebidos.
- `assets/install-autosync.ps1 -Minutes N` crea la Scheduled Task `SharedBrainSync` que corre el wrapper.
- `assets/uninstall-autosync.sh` / `uninstall-autosync.ps1` lo quitan manualmente.

El sync corre durante el hackatón y se apaga solo al terminar, sin dejar un demonio consumiendo.

## Assets

| Asset | Uso |
|-------|-----|
| `vault-template/` | Copiar a `~/SharedBrain` al crear el cerebro (HUB). |
| `agents-snippet.md` | Bloque `## Cerebro compartido` para el `AGENTS.md` del repo de código. |
| `brain.yaml` | Template que va en la raíz del repo de código y apunta al cerebro. |
| `install-skills.sh` / `.ps1` | Instalan en los agentes las skills de `team/skills/` del cerebro. |
| `autosync-brain.sh` / `.ps1` | Wrapper con TTL llamado por cron / Scheduled Task. |
| `install-autosync.sh` / `.ps1` | Registran el autosync cada N minutos. |
| `uninstall-autosync.sh` / `.ps1` | Quitan el autosync manualmente. |

## Reglas

- El repo del cerebro es siempre privado; cada persona usa su propia cuenta de GitHub.
- Nunca guardar secretos, tokens, credenciales ni `.env` en el vault.
- Nunca `git push --force` ni `git reset --hard` sobre el cerebro. Ante conflicto, conservar ambas versiones y resolver explícitamente.
