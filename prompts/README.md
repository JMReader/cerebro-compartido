# Prompts de onboarding

Cada persona necesita:

1. Una cuenta de GitHub invitada como colaboradora del repo privado del cerebro.
2. Clonar o descomprimir este kit.
3. Abrir su agente (Codex, Claude, Devin, etc.) en la carpeta del kit.
4. Pegar solamente el prompt correspondiente a su computadora, reemplazando `<repo-url>` y `<participant-id>`.

No se usa Tailscale ni Syncthing. GitHub sincroniza el contenido y los scripts incluidos instalan las skills en el agente. Alternativa sin vault: `bash install.sh` instala la skill directo en la máquina; en Claude Code, `/plugin marketplace add JMReader/cerebro-compartido`.

Asignaciones:

- `01-BRAIN-HUB.md`: computadora administradora (crea el cerebro).
- `02-PARTICIPANTE.md`: una copia por cada integrante, cambiando `<participant-id>`.

Opcional: definir `HACKATHON` y `HACKATHON_ENDS` en el ambiente antes de correr `setup-client` para que la máquina registre en qué evento está y cuándo termina.
