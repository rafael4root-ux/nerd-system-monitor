# Nerd System Monitor

Sistema de monitoramento e gerenciamento para Linux (Pop!_OS / Ubuntu / GNOME).

Widget Conky no desktop + painéis interativos via Rofi para gerenciar processos, Docker e serviços systemd.

## Screenshots

Widget Conky exibe em tempo real:
- CPU, RAM, GPU (NVIDIA), Battery, Storage, Network
- Portas abertas (listening ports)
- Conexões ativas
- Containers Docker
- Top processos (CPU/MEM)
- Serviços systemd

## Estrutura

```
/opt/nerd-system-monitor/
├── bin/
│   ├── nerd-station            # Painel principal (Super+N)
│   ├── nerd-process-manager    # Gerenciador de processos (Super+K)
│   ├── nerd-docker-manager     # Gerenciador Docker (Ctrl+Alt+D)
│   └── nerd-service-manager    # Gerenciador de serviços (Ctrl+Alt+S)
├── config/
│   ├── conky/
│   │   └── nerd-monitor.conf   # Config do widget Conky
│   └── rofi/
│       └── nerd-theme.rasi     # Tema Rofi para os painéis
├── install.sh                  # Script de instalação
├── .gitignore
└── README.md
```

## Dependências

- `conky-all` - Widget no desktop
- `rofi` - Menus interativos
- `btop` / `glances` / `nmon` - Monitores de terminal
- `nvidia-smi` - Monitoramento GPU (opcional)
- `docker` - Gerenciamento de containers (opcional)
- Font: `JetBrains Mono`

## Instalação

```bash
git clone <repo-url> /opt/nerd-system-monitor
cd /opt/nerd-system-monitor
./install.sh
```

## Atalhos de Teclado

| Atalho | Ação |
|---|---|
| `Super+N` | Nerd Station (painel principal) |
| `Super+K` | Kill/gerenciar processos |
| `Ctrl+Alt+D` | Docker Manager |
| `Ctrl+Alt+S` | Service Manager |

## Funcionalidades

### Process Manager
- Lista processos ordenados por CPU
- Enviar sinais: SIGTERM, SIGKILL, SIGSTOP, SIGCONT, SIGHUP
- Confirmação antes de matar
- Escalação automática para sudo

### Docker Manager
- Listar containers (running/stopped)
- Start, Stop, Restart, Pause, Remove
- Logs, Shell, Stats, Inspect
- Docker Compose Up/Down
- Stop All, Restart All, Prune

### Service Manager
- Serviços running, failed, enabled
- Start, Stop, Restart, Reload
- Enable/Disable no boot
- Mask/Unmask
- Logs via journalctl
- Análise de tempo de boot

### Nerd Station (Menu Principal)
- Acesso rápido a todos os managers
- Abrir btop, glances, nmon
- Ver portas e conexões
- Scan WiFi
- System cleanup
- Sensores de temperatura
- Uso de disco

## Licença

MIT
