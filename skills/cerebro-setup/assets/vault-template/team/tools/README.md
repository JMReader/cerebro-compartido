# Herramientas del equipo

Para traer y publicar cambios del cerebro:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:BRAIN_ROOT\team\tools\sync-brain.ps1"
```

```bash
bash "$BRAIN_ROOT/team/tools/sync-brain.sh"
```

Ejecutar al empezar y terminar cada sesión. Nunca usar `push --force` sobre `main`.
