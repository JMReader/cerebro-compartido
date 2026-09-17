# Sincronizar el cerebro

La rama compartida es `origin/main`. Usar el script del vault:

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:BRAIN_ROOT\team\tools\sync-brain.ps1"
```

macOS:

```bash
bash "$BRAIN_ROOT/team/tools/sync-brain.sh"
```

El script agrega y confirma cambios locales, ejecuta `git pull --rebase` y publica con `git push`. Reintenta una vez si otro participante publicó en el medio.

Si aparece un conflicto, detenerse. No usar `push --force`, `reset --hard` ni borrar la versión ajena. Resolver el archivo, ejecutar las pruebas relevantes y volver a sincronizar.
