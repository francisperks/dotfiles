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
  noto-fonts ttf-jetbrains-mono playerctl pavucontrol \
  sddm \
  ttf-font-awesome ttf-material-icons ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

# ─────────────────────────────────────────────
# 🛠️ Enable essential services
# ─────────────────────────────────────────────
sudo systemctl enable NetworkManager.service
sudo systemctl enable sddm.service

# ─────────────────────────────────────────────
# 🖥️ Hyprland session for SDDM
# ─────────────────────────────────────────────
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF

# ─────────────────────────────────────────────
# 🔐 Optional: Configure autologin
# ─────────────────────────────────────────────
read -p "👉 Enable autologin for user '$USER'? (y/N): " AUTOLOGIN
if [[ "$AUTOLOGIN" =~ ^[Yy]$ ]]; then
  sudo mkdir -p /etc/sddm.conf.d
  sudo tee /etc/sddm.conf.d/hyprland.conf > /dev/null <<EOF
[Autologin]
User=$USER
Session=hyprland

[General]
Session=hyprland
EOF
  echo "✅ Autologin configured for $USER"
fi

# ─────────────────────────────────────────────
# 📁 XDG User Directories
# ─────────────────────────────────────────────
xdg-user-dirs-update

# ─────────────────────────────────────────────
# 🔗 Link dotfiles
# ─────────────────────────────────────────────
DOTFILES_DIR="$HOME/dotfiles"

if [ -f "$DOTFILES_DIR/local/bin/link-dotfiles.sh" ]; then
  echo "🔗 Running dotfile linker..."
  chmod +x "$DOTFILES_DIR/local/bin/link-dotfiles.sh"
  "$DOTFILES_DIR/local/bin/link-dotfiles.sh"
else
  echo "⚠️ Dotfile linker not found at $DOTFILES_DIR/local/bin/link-dotfiles.sh"
fi

# ─────────────────────────────────────────────
# 🎉 Final Message
# ─────────────────────────────────────────────
echo "✅ All done! Reboot and log in to Hyprland via SDDM."
