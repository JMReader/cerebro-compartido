---
name: cerebro-cierre
description: Cerrar una tarea, spec, feature o decisión dejando memoria en el cerebro compartido — nota de sesión, INDEX actualizado y decisión del equipo si aplica — para que la próxima tarea arranque sin re-descubrir contexto.
---

# Cerrar y dejar memoria

Invocar al terminar una tarea, spec o feature, o cuando se toma una decisión. El objetivo es que la próxima sesión arranque desde el INDEX en vez de re-descubrir contexto (ahorra tokens).

## Pasos

1. Sync primero con `team/tools/sync-brain.sh` (macOS) o `sync-brain.ps1` (Windows).
2. Crear `each_one/<participant-id>/sessions/YYYY-MM-DD-<tema>.md` desde `_templates/session.md`: qué se hizo, decisiones, pendientes y links. Si ya existe el archivo, agregar sufijo horario; nunca sobrescribir.
3. Actualizar `each_one/<participant-id>/INDEX.md` con el estado actual y el enlace a la sesión.
4. Si se tomó una decisión del equipo: crear `team/decisions/YYYY-MM-DD-<slug>.md` desde `_templates/decision.md` y agregar UNA fila a `team/decisions/INDEX.md` (releerlo justo antes de editar). Si reemplaza una decisión previa, marcarla `superseded` y enlazar ambas; no borrarla.
5. Sync final con `team/tools/sync-brain`.

## Reglas

- Escribir sólo en el `each_one/` propio, salvo decisiones comunes en `team/decisions/`.
- CREATE > UPDATE > DELETE: crear notas nuevas antes que modificar compartidas.
- Ante conflicto de Git, conservar ambas versiones y resolver explícitamente; nunca `push --force` ni `reset --hard`.
- Nunca guardar secretos, tokens, credenciales ni archivos `.env`.
- Reportar rutas modificadas y el commit publicado.
