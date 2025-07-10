#!/bin/bash
set -e

echo "🖼️ Installing swww (wallpaper daemon)..."

if ! command -v yay &>/dev/null; then
  echo "📦 yay not found, installing..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

yay -S --noconfirm swww

# Create a wallpapers folder if needed
mkdir -p "$HOME/Pictures/wallpapers"

echo "✅ swww installed. Add 'swww init' and a wallpaper command to your Hyprland config or autostart."
