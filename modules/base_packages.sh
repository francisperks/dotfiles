#!/bin/bash

# Base packages installation module
install_base() {
  echo "📦 Installing base packages..."
  sudo pacman -Syu --noconfirm \
    hyprland \
    kitty wofi waybar \
    networkmanager network-manager-applet \
    xdg-desktop-portal xdg-desktop-portal-hyprland \
    pipewire pipewire-pulse wireplumber \
    wl-clipboard \
    noto-fonts ttf-jetbrains-mono \
    playerctl pavucontrol unzip git base-devel \
    grim slurp swappy \
    polkit-gnome \
    sddm
  echo "✅ Base packages installed"
} 