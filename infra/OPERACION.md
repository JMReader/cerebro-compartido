# Operación del cerebro compartido con GitHub

## Modelo de acceso

El repositorio del cerebro es **privado**. Cada integrante usa su propia cuenta de GitHub; no se comparten contraseñas, tokens ni claves.

Alta:

1. El administrador agrega el usuario en Settings → Collaborators.
2. La persona acepta la invitación.
3. Instala Git, GitHub CLI y Obsidian (los scripts de setup lo hacen solos).
4. Ejecuta `gh auth login` y el bootstrap de su sistema.

Baja: quitar el usuario de Collaborators. Su copia local seguirá existiendo, pero dejará de recibir y publicar cambios.

## Rutina simple

Al empezar y terminar una sesión ejecutar:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:BRAIN_ROOT\team\tools\sync-brain.ps1"
```

```bash
bash "$BRAIN_ROOT/team/tools/sync-brain.sh"
```

El script crea un commit si hay cambios, ejecuta `pull --rebase` y luego `push`. Reintenta una vez si otro participante publicó al mismo tiempo.

## Sincronización automática durante el hackatón

Para que cada máquina publique y traiga cambios cada minuto sin intervención:

```bash
bash infra/macos/install-autosync.sh        # cron
```

```powershell
powershell -ExecutionPolicy Bypass -File infra\windows\install-autosync.ps1   # tarea programada
```

Al terminar el evento, desinstalar con `uninstall-autosync.sh` / `uninstall-autosync.ps1`. Nada queda corriendo: es configuración por máquina, no permanente.

## Evitar conflictos

- Cada persona escribe por defecto en `each_one/<participant-id>/`.
- Crear notas nuevas antes de modificar una compartida.
- Sincronizar antes de tocar `team/decisions/INDEX.md` u otro índice común.
- Usar nombres únicos con fecha y participante para capturas.
- Si Git informa un conflicto, detenerse y resolverlo; nunca usar `push --force` ni `reset --hard`.

## Archivos grandes

Mantener Markdown y capturas livianas en Git. Para archivos mayores a 20 MB, guardar un link en `team/links/`. GitHub bloquea archivos individuales de 100 MB o más.

## Recuperación

GitHub y cada clon conservan el historial. Para recuperar algo, revisar `git log` y restaurar el archivo en una ruta nueva antes de reemplazar la versión vigente.
