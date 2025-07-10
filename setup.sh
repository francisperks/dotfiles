#!/bin/bash
set -e

echo "🚀 Setting up base Hyprland environment..."

# ─────────────────────────────────────────────
# 📦 Install essential packages
# ─────────────────────────────────────────────
sudo pacman -Syu --noconfirm \
  hyprland kitty wofi waybar \
  dolphin dunst grim slurp uwsm \
  qt5-wayland qt6-wayland \
  xdg-desktop-portal xdg-desktop-portal-hyprland \
  polkit-kde-agent seatd \
  pipewire pipewire-pulse wireplumber \
  wl-clipboard \
  networkmanager network-manager-applet \
  xdg-user-dirs unzip git base-devel \
  noto-fonts ttf-jetbrains-mono playerctl pavucontrol

# ─────────────────────────────────────────────
# 🛠️ Enable essential services
# ─────────────────────────────────────────────
sudo systemctl enable NetworkManager.service

# ─────────────────────────────────────────────
# 📁 XDG User Directories
# ─────────────────────────────────────────────
xdg-user-dirs-update

# ─────────────────────────────────────────────
# 🔗 Link dotfiles
# ─────────────────────────────────────────────
DOTFILES_DIR="$HOME/dotfiles"  # adjust if your repo is elsewhere

if [ -f "$DOTFILES_DIR/local/bin/link-dotfiles.sh" ]; then
  echo "🔗 Running dotfile linker..."
  chmod +x "$DOTFILES_DIR/local/bin/link-dotfiles.sh"
  "$DOTFILES_DIR/local/bin/link-dotfiles.sh"
else
  echo "⚠️ Dotfile linker not found at $DOTFILES_DIR/local/bin/link-dotfiles.sh"
fi

# ─────────────────────────────────────────────
# 🎨 Optional: Fonts and Appearance (JetBrains Mono, Noto)
# ─────────────────────────────────────────────
# Already installed via pacman above

# ─────────────────────────────────────────────
# 🎉 Final Message
# ─────────────────────────────────────────────
echo "✅ All done! Reboot and log in to Hyprland from your display manager or TTY."
