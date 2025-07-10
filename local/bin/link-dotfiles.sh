#!/bin/bash
set -e

echo "🔗 Linking Hyprland config..."

mkdir -p ~/.config/hypr
ln -sf "$(pwd)/config/hypr/hyprland.conf" ~/.config/hypr/hyprland.conf

echo "✅ Linked: ~/.config/hypr/hyprland.conf"
