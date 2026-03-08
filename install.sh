#!/bin/bash
# ═══════════════════════════════════════════════
# Nerd System Monitor - Installer
# ═══════════════════════════════════════════════

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONKY_DIR="$HOME/.config/conky"
ROFI_DIR="$HOME/.config/rofi"
AUTOSTART_DIR="$HOME/.config/autostart"

echo "⚡ Nerd System Monitor - Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Install dependencies
echo "[1/5] Installing dependencies..."
sudo apt update -qq
sudo apt install -y conky-all rofi btop glances nmon 2>/dev/null || true
echo "  ✓ Dependencies installed"

# 2. Create directories
echo "[2/5] Creating directories..."
mkdir -p "$BIN_DIR" "$CONKY_DIR" "$ROFI_DIR" "$AUTOSTART_DIR"
echo "  ✓ Directories created"

# 3. Symlink scripts
echo "[3/5] Linking scripts to $BIN_DIR..."
for script in nerd-station nerd-process-manager nerd-docker-manager nerd-service-manager; do
    ln -sf "$SCRIPT_DIR/bin/$script" "$BIN_DIR/$script"
    echo "  ✓ $script"
done

# 4. Symlink configs
echo "[4/5] Linking configs..."
ln -sf "$SCRIPT_DIR/config/conky/nerd-monitor.conf" "$CONKY_DIR/nerd-monitor.conf"
ln -sf "$SCRIPT_DIR/config/rofi/nerd-theme.rasi" "$ROFI_DIR/nerd-theme.rasi"
ln -sf "$SCRIPT_DIR/config/conky/nerd-monitor.desktop" "$AUTOSTART_DIR/nerd-monitor.desktop"
echo "  ✓ Conky config linked"
echo "  ✓ Conky autostart linked"
echo "  ✓ Rofi theme linked"

# 5. Setup keyboard shortcuts (GNOME)
echo "[5/5] Setting up keyboard shortcuts..."
if command -v gsettings &>/dev/null; then
    EXISTING=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "@as []")
    
    SHORTCUTS=(
        "nerd-station|Nerd Station|$BIN_DIR/nerd-station|<Ctrl><Alt>n"
        "nerd-process|Nerd Process Manager|$BIN_DIR/nerd-process-manager|<Ctrl><Alt>k"
        "nerd-docker|Nerd Docker Manager|$BIN_DIR/nerd-docker-manager|<Ctrl><Alt>d"
        "nerd-service|Nerd Service Manager|$BIN_DIR/nerd-service-manager|<Ctrl><Alt>s"
    )

    PATHS="$EXISTING"
    for entry in "${SHORTCUTS[@]}"; do
        IFS='|' read -r id name cmd binding <<< "$entry"
        BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$id/"
        
        # Add path if not already present
        if [[ "$PATHS" != *"$id"* ]]; then
            PATHS=$(echo "$PATHS" | sed "s/]/, '$BASE']/; s/\[, /[/")
        fi
        
        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE" name "$name"
        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE" command "$cmd"
        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE" binding "$binding"
    done
    
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$PATHS"
    echo "  ✓ Keyboard shortcuts configured"
else
    echo "  ⚠ gsettings not found, skipping keyboard shortcuts"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚡ Installation complete!"
echo ""
echo "  Start Conky widget:"
echo "    conky -c ~/.config/conky/nerd-monitor.conf &"
echo ""
echo "  ⌨  Atalhos / Shortcuts:"
echo "    Ctrl+Alt+N    → Nerd Station (menu principal)"
echo "    Ctrl+Alt+K    → Process Manager"  
echo "    Ctrl+Alt+D    → Docker Manager"
echo "    Ctrl+Alt+S    → Service Manager"
echo ""
echo "  📋 Opções do menu:"
echo "    Gerenciamento: Processos, Docker, Serviços"
echo "    Abrir: btop, glances, nmon, Arquivos, Config, Terminal"
echo "    Rede: Portas, Conexões, WiFi"
echo "    Sistema: Cleanup, Bateria, Sensores, Disco, Pacotes, Info"
echo "    Ajuda: ⌨ Atalhos do Teclado"
echo ""
echo "  Or run directly:"
echo "    nerd-station"
echo "    nerd-process-manager"
echo "    nerd-docker-manager"
echo "    nerd-service-manager"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
