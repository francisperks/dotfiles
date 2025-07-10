#!/bin/bash
set -e

# ─────────────────────────────────────────────
# 🛑 Check if running as root
# ─────────────────────────────────────────────
if [ "$EUID" -eq 0 ]; then
  echo "❌ Please run this script as your user, not as root."
  exit 1
fi

echo "🚀 Setting up base Hyprland environment..."

# ─────────────────────────────────────────────
# 📦 Install essential packages (from pacman)
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
  noto-fonts playerctl pavucontrol sddm \
  ttf-font-awesome ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

# ─────────────────────────────────────────────
# 📦 Install ttf-jetbrains-mono-nerd from AUR
# ─────────────────────────────────────────────
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
  echo "🔍 Installing JetBrainsMono Nerd Font from AUR..."

  if ! command -v yay &>/dev/null; then
    echo "📦 yay not found. Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi

  yay -S --noconfirm ttf-jetbrains-mono-nerd
else
  echo "✅ JetBrainsMono Nerd Font already installed"
fi

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
# 🔐 Optional: Install Hyprlock + Hypridle Module
# ─────────────────────────────────────────────
read -p "👉 Install Hyprlock + Hypridle module? (y/N): " LOCKMOD
if [[ "$LOCKMOD" =~ ^[Yy]$ ]]; then
  LOCK_MODULE="$HOME/dotfiles/modules/hyprlock-idle/setup.sh"
  if [ -f "$LOCK_MODULE" ]; then
    chmod +x "$LOCK_MODULE"
    "$LOCK_MODULE"
  else
    echo "❌ Hyprlock module not found at $LOCK_MODULE"
  fi
fi

# ─────────────────────────────────────────────
# 🎉 Final Message
# ─────────────────────────────────────────────
echo "✅ All done! Reboot and log in to Hyprland via SDDM."
read -p "🔁 Reboot now to start Hyprland? (y/N): " REBOOT
[[ "$REBOOT" =~ ^[Yy]$ ]] && reboot
