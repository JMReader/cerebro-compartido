# Cerrar una sesión

1. Crear `each_one/<participant-id>/sessions/YYYY-MM-DD-<tema>.md` desde `_templates/session.md`. Si existe, usar un sufijo horario; no sobrescribir.
2. Registrar resultados concretos, decisiones, pendientes y links. Omitir secciones vacías.
3. Actualizar `each_one/<participant-id>/INDEX.md` con el estado actual y enlaces a la sesión.
4. Si cambió el estado compartido de un proyecto, releer y actualizar `team/projects/<project>/INDEX.md`.
5. Si se tomó una decisión común, crear una nota separada según `decision.md` y enlazarla al índice.
6. Guardar binarios en `artifacts/` personal o `team/captures/`; nunca incrustar secretos.
7. Ejecutar `team/tools/sync-brain.ps1` en Windows o `sync-brain.sh` en macOS para commit, rebase y push.
8. Reportar rutas modificadas, commit publicado y cualquier conflicto Git observado.
