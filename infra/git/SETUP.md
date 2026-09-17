# Configuración Git

## Administrador

```bash
gh auth login
gh repo create <org>/<repo-del-cerebro> --private
```

Agregar colaboradores desde `https://github.com/<org>/<repo-del-cerebro>/settings/access` o con:

```bash
gh api --method PUT repos/<org>/<repo-del-cerebro>/collaborators/USERNAME -f permission=push
```

## Participante

Después de aceptar la invitación:

```bash
gh auth login
```

El bootstrap (`setup-client`) clona el cerebro, instala la skill y define `BRAIN_ROOT` y `PARTICIPANT_ID`.
