#!/bin/bash
set -e

echo "🔐 Setting up Hyprlock and Hypridle..."

# ─────────────────────────────────────────────
# 📦 Install hyprlock + hypridle
# ─────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
  echo "📦 yay not found, installing..."
  git clone https://aur.archlinux.org/yay.git ~/yay
  (cd ~/yay && makepkg -si --noconfirm)
  rm -rf ~/yay
fi

yay -S --noconfirm hyprlock hypridle

# ─────────────────────────────────────────────
# 📁 Create config directory
# ─────────────────────────────────────────────
mkdir -p ~/.config/hypr

# 🔗 Symlink configs from module
DOTFILES_DIR="$HOME/dotfiles/modules/hyprlock-idle"

ln -sf "$DOTFILES_DIR/hyprlock.conf" ~/.config/hypr/hyprlock.conf
ln -sf "$DOTFILES_DIR/hypridle.conf" ~/.config/hypr/hypridle.conf

echo "✅ Hyprlock and Hypridle setup complete."
