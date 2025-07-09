#!/bin/bash

set -e  # Exit on error

echo "🔧 Installing core packages..."
sudo pacman -Syu --noconfirm \
  kitty hyprland waybar rofi neofetch \
  ttf-jetbrains-mono \
  noto-fonts \
  network-manager-applet \
  wl-clipboard \
  xdg-desktop-portal-hyprland \
  sddm \
  unzip git base-devel

# Optional AUR packages
if ! command -v yay &> /dev/null; then
  echo "📦 Installing yay..."
  git clone https://aur.archlinux.org/yay.git ~/yay
  (cd ~/yay && makepkg -si --noconfirm)
fi

yay -S --noconfirm \
  ttf-jetbrains-mono-nerd \
  wlogout

echo "📁 Creating config symlinks..."
CONFIGS=("kitty" "hypr" "waybar" "rofi")

for dir in "${CONFIGS[@]}"; do
  target="$HOME/.config/$dir"
  src="$HOME/dotfiles/$dir"
  
  if [ -L "$target" ] || [ -d "$target" ]; then
    echo "⚠️  Skipping existing $target"
  else
    ln -s "$src" "$target"
    echo "✅ Linked $src → $target"
  fi
done

# Kitty theme loader
if [ -d "$HOME/.config/kitty-themes" ]; then
  echo "🎨 Kitty themes already cloned"
else
  git clone https://github.com/dexpota/kitty-themes ~/.config/kitty-themes
  cp ~/.config/kitty-themes/themes/Dracula.conf ~/.config/kitty/theme.conf
  echo "include theme.conf" >> ~/.config/kitty/kitty.conf
fi

echo "✅ Setup complete. Reboot or log out to start Hyprland."
