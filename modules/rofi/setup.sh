#!/bin/bash
set -e

echo "🧠 Installing Rofi (optional fallback launcher)..."

sudo pacman -S --noconfirm rofi

# Optional: symlink config if using dotfiles/config/rofi/
ROFI_CONF="$HOME/dotfiles/config/rofi"
if [ -d "$ROFI_CONF" ]; then
  mkdir -p ~/.config/rofi
  ln -sf "$ROFI_CONF/config.rasi" ~/.config/rofi/config.rasi
  echo "🔗 Linked rofi config."
fi

echo "✅ Rofi installed. Set keybind to: rofi -show drun"
