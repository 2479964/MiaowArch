#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
INSTALL_PKGS=true
PKG_ONLY=false
ASSUME_YES=false

PACMAN_PACKAGES=(
    hyprland waybar kitty wofi swww dunst btop playerctl
    ttf-jetbrains-mono noto-fonts-emoji
    brightnessctl pipewire wireplumber
    xdg-utils thunar wlogout
)
AUR_PACKAGES=(hypridle hyprlock hyprpaper cava grimblast-git)

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
BLUE='\033[34m'
BOLD='\033[1m'
RESET='\033[0m'

warn_count=0

print_banner() {
    printf '\n'
    printf '%b\n' "${BOLD}🐈 MiaowArch (CAT OS) Installer${RESET}"
    printf '%b\n' "Deploy Hyprland + CAT OS config on Arch Linux."
    printf '\n'
}

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --no-pkg       Deploy configuration files only (skip package installation)
  --pkg-only     Install packages only (skip config deployment)
  -y, --yes      Non-interactive mode, assume "yes" to prompts
  -h, --help     Show this help
EOF
}

ok()   { printf '%b\n' "${GREEN}  ✔${RESET} $*"; }
info() { printf '%b\n' "${YELLOW}  •${RESET} $*"; }
step() { printf '\n%b\n' "${BLUE}${BOLD}==> $*${RESET}"; }
warn() { warn_count=$((warn_count + 1)); printf '%b\n' "${YELLOW}  ⚠${RESET} $*"; }
err()  { printf '%b\n' "${RED}  ✖${RESET} $*" >&2; }

ask_yes_no() {
    local prompt="$1"
    local answer
    if $ASSUME_YES; then
        info "$prompt [auto-yes]"
        return 0
    fi
    read -r -p "$prompt [Y/n] " answer
    [[ -z "$answer" || "$answer" =~ ^[Yy]([Ee][Ss])?$ ]]
}

backup_path() {
    local path="$1"
    printf '%s.bak.%(%Y%m%d-%H%M%S)T' "$path" -1
}

link_file() {
    local src="$1" dst="$2" backup
    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            ok "Already linked: $dst"
            return 0
        fi
        backup="$(backup_path "$dst")"
        info "Backing up existing symlink: $dst -> $backup"
        mv "$dst" "$backup"
    elif [[ -e "$dst" ]]; then
        backup="$(backup_path "$dst")"
        info "Backing up existing file: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    ok "Linked $dst"
}

find_aur_helper() {
    if command -v yay >/dev/null 2>&1; then
        printf 'yay'
        return 0
    fi
    if command -v paru >/dev/null 2>&1; then
        printf 'paru'
        return 0
    fi
    return 1
}

install_packages() {
    step "Installing packages"

    if ! command -v pacman >/dev/null 2>&1; then
        err "pacman not found. This installer is for Arch Linux."
        exit 1
    fi
    if ! command -v sudo >/dev/null 2>&1; then
        err "sudo is required to install packages."
        exit 1
    fi

    if ask_yes_no "Install official repo packages with pacman?"; then
        sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
        ok "Pacman packages installed"
    else
        warn "Skipped pacman package installation"
    fi

    local aur_helper
    if aur_helper="$(find_aur_helper)"; then
        if ask_yes_no "Install AUR packages with ${aur_helper}?"; then
            "${aur_helper}" -S --needed --noconfirm "${AUR_PACKAGES[@]}"
            ok "AUR packages installed"
        else
            warn "Skipped AUR package installation"
        fi
    else
        warn "No AUR helper found (yay/paru). Skipping: ${AUR_PACKAGES[*]}"
        info "Install yay or paru, then run:"
        printf '      yay -S %s\n' "${AUR_PACKAGES[*]}"
    fi
}

deploy_configs() {
    step "Deploying configuration files"

    link_file "$DOTFILES_DIR/hypr/hyprland.conf"  "$CONFIG_DIR/hypr/hyprland.conf"
    link_file "$DOTFILES_DIR/hypr/hypridle.conf"  "$CONFIG_DIR/hypr/hypridle.conf"
    link_file "$DOTFILES_DIR/hypr/hyprlock.conf"  "$CONFIG_DIR/hypr/hyprlock.conf"
    link_file "$DOTFILES_DIR/waybar/config.jsonc" "$CONFIG_DIR/waybar/config.jsonc"
    link_file "$DOTFILES_DIR/waybar/style.css"    "$CONFIG_DIR/waybar/style.css"
    link_file "$DOTFILES_DIR/dunst/dunstrc"       "$CONFIG_DIR/dunst/dunstrc"
    link_file "$DOTFILES_DIR/kitty/kitty.conf"    "$CONFIG_DIR/kitty/kitty.conf"
}

deploy_catos_scripts() {
    step "Deploying catOS scripts"

    local dst
    mkdir -p "$CONFIG_DIR/catOS"
    for script in "$DOTFILES_DIR/catOS/"*.sh; do
        dst="$CONFIG_DIR/catOS/$(basename "$script")"
        link_file "$script" "$dst"
        chmod +x "$dst"
        ok "Executable $dst"
    done
}

prepare_wallpapers_dir() {
    step "Preparing wallpapers directory"

    mkdir -p "$CONFIG_DIR/wallpapers"
    if [[ -z "$(find "$CONFIG_DIR/wallpapers" -maxdepth 1 -type f -print -quit)" ]]; then
        info "Add wallpaper images to: $CONFIG_DIR/wallpapers"
    fi
}

check_arch_environment() {
    step "Checking environment"

    if [[ ! -f /etc/arch-release ]]; then
        warn "Non-Arch system detected. Package installation may fail."
        if ! ask_yes_no "Continue anyway?"; then
            info "Installer cancelled by user."
            exit 0
        fi
    else
        ok "Arch Linux detected"
    fi

    if [[ "$(id -u)" -eq 0 ]]; then
        warn "Running as root is not recommended. Use a regular user with sudo."
    fi
}

parse_args() {
    for arg in "$@"; do
        case "$arg" in
            --no-pkg) INSTALL_PKGS=false ;;
            --pkg-only) PKG_ONLY=true ;;
            -y|--yes) ASSUME_YES=true ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                err "Unknown option: $arg"
                usage
                exit 1
                ;;
        esac
    done

    if ! $INSTALL_PKGS && $PKG_ONLY; then
        err "Cannot use --no-pkg and --pkg-only together."
        exit 1
    fi
}

main() {
    parse_args "$@"
    print_banner
    check_arch_environment

    if $INSTALL_PKGS; then
        install_packages
    else
        info "Skipping package installation (--no-pkg)"
    fi

    if ! $PKG_ONLY; then
        deploy_configs
        deploy_catos_scripts
        prepare_wallpapers_dir
    else
        info "Skipping config deployment (--pkg-only)"
    fi

    printf '\n%b\n' "${GREEN}${BOLD}Done! MiaowArch (CAT OS) setup finished.${RESET}"
    printf '%b\n' "  • Log out and select Hyprland, or run: Hyprland"
    if (( warn_count > 0 )); then
        printf '%b\n' "  • Completed with ${warn_count} warning(s). Review messages above."
    fi
    printf '\n'
}

main "$@"
