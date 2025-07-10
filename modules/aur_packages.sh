#!/bin/bash

# AUR packages installation module
install_aur() {
  echo "📦 Installing AUR packages..."
  
  if ! command -v yay &>/dev/null; then
    echo "📦 Installing yay..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    (cd ~/yay && makepkg -si --noconfirm)
    rm -rf ~/yay
  fi

  yay -S --noconfirm \
    ttf-jetbrains-mono-nerd \
    visual-studio-code-bin \
    wlogout \
    neofetch
    
  echo "✅ AUR packages installed"
} 