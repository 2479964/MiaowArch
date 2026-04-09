#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║         CAT OS — Hyprland Chaotic Build              ║
# ║             install.sh  ·  deploy dotfiles           ║
# ╚══════════════════════════════════════════════════════╝
#
# Usage:
#   ./install.sh           — deploy configs + install packages
#   ./install.sh --no-pkg  — deploy configs only (skip pacman)
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
INSTALL_PKGS=true

# ── Parse flags ─────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --no-pkg) INSTALL_PKGS=false ;;
        -h|--help)
            echo "Usage: $0 [--no-pkg]"
            exit 0
            ;;
    esac
done

# ── Colour helpers ───────────────────────────────────────
ok()   { printf '\e[32m  ✔  %s\e[0m\n' "$*"; }
info() { printf '\e[33m  ─  %s\e[0m\n' "$*"; }
err()  { printf '\e[31m  ✖  %s\e[0m\n' "$*" >&2; }

# ── Symlink helper ───────────────────────────────────────
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        info "Backing up existing $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sf "$src" "$dst"
    ok "Linked $dst"
}

# ── 1. Install packages ──────────────────────────────────
if $INSTALL_PKGS; then
    info "Installing pacman packages…"
    sudo pacman -S --needed --noconfirm \
        hyprland waybar kitty wofi swww dunst btop playerctl \
        ttf-jetbrains-mono noto-fonts-emoji \
        brightnessctl pipewire wireplumber \
        xdg-utils thunar wlogout

    if command -v yay &>/dev/null; then
        info "Installing AUR packages with yay…"
        yay -S --needed --noconfirm \
            hypridle hyprlock hyprpaper cava grimblast-git
    else
        err "yay not found — skipping AUR packages (hypridle, hyprlock, hyprpaper, cava, grimblast)"
        err "Install yay then run:  yay -S hypridle hyprlock hyprpaper cava grimblast-git"
    fi
fi

# ── 2. Deploy configs ────────────────────────────────────
info "Deploying config files…"

link "$DOTFILES_DIR/hypr/hyprland.conf"  "$CONFIG_DIR/hypr/hyprland.conf"
link "$DOTFILES_DIR/hypr/hypridle.conf"  "$CONFIG_DIR/hypr/hypridle.conf"
link "$DOTFILES_DIR/hypr/hyprlock.conf"  "$CONFIG_DIR/hypr/hyprlock.conf"

link "$DOTFILES_DIR/waybar/config.jsonc" "$CONFIG_DIR/waybar/config.jsonc"
link "$DOTFILES_DIR/waybar/style.css"    "$CONFIG_DIR/waybar/style.css"

link "$DOTFILES_DIR/dunst/dunstrc"       "$CONFIG_DIR/dunst/dunstrc"
link "$DOTFILES_DIR/kitty/kitty.conf"    "$CONFIG_DIR/kitty/kitty.conf"

# ── 3. catOS scripts ─────────────────────────────────────
info "Deploying catOS chaos scripts…"

mkdir -p "$CONFIG_DIR/catOS"
for script in "$DOTFILES_DIR/catOS/"*.sh; do
    dst="$CONFIG_DIR/catOS/$(basename "$script")"
    link "$script" "$dst"
    chmod +x "$dst"
done

# ── 4. Wallpapers directory ──────────────────────────────
info "Setting up wallpapers directory…"
mkdir -p "$HOME/.config/wallpapers"
if [[ ! -f "$HOME/.config/wallpapers/current.jpg" ]]; then
    info "Add wallpapers to ~/.config/wallpapers/  (no default provided)"
fi

# ── Done ─────────────────────────────────────────────────
echo ""
echo "  🐈  CAT OS installed."
echo "  ─   Log out and select Hyprland from your display manager."
echo "  ─   Or run:  Hyprland"
echo ""
