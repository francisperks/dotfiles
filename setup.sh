#!/bin/bash
set -e

echo "🚀 Starting full Hyprland setup on minimal Arch..."

# ─────────────────────────────────────────
# 📦 Base packages
# ─────────────────────────────────────────
install_base() {
  sudo pacman -Syu --noconfirm \
    hyprland \
    kitty rofi waybar \
    networkmanager network-manager-applet \
    xdg-desktop-portal xdg-desktop-portal-hyprland \
    pipewire pipewire-pulse wireplumber \
    wl-clipboard \
    noto-fonts ttf-jetbrains-mono \
    playerctl pavucontrol unzip git base-devel \
    grim slurp swappy \
    polkit-gnome \
    sddm
}
install_base

# ─────────────────────────────────────────
# 📦 AUR (yay + nerd fonts + vscode + wlogout)
# ─────────────────────────────────────────
install_aur() {
  if ! command -v yay &>/dev/null; then
    echo "📦 Installing yay..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    (cd ~/yay && makepkg -si --noconfirm)
  fi

  yay -S --noconfirm \
    ttf-jetbrains-mono-nerd \
    visual-studio-code-bin \
    wlogout \
    neofetch
}
install_aur

# ─────────────────────────────────────────
# 🔗 Dotfiles symlinks
# ─────────────────────────────────────────
link_configs() {
  for cfg in kitty rofi waybar hypr; do
    target="$HOME/.config/$cfg"
    source="$HOME/dotfiles/$cfg"

    if [ -L "$target" ] || [ -d "$target" ]; then
      echo "⚠️  $cfg already exists, skipping..."
    else
      ln -s "$source" "$target"
      echo "✅ Linked $cfg config"
    fi
  done
}
link_configs

# ─────────────────────────────────────────
# 🎨 Kitty themes
# ─────────────────────────────────────────
setup_kitty_themes() {
  if [ ! -d "$HOME/.config/kitty-themes" ]; then
    git clone https://github.com/dexpota/kitty-themes ~/.config/kitty-themes
    cp ~/.config/kitty-themes/themes/Dracula.conf ~/.config/kitty/theme.conf
    echo "include theme.conf" >> ~/.config/kitty/kitty.conf
  fi
}
setup_kitty_themes

# ─────────────────────────────────────────
# ⚡ Enable system services
# ─────────────────────────────────────────
enable_services() {
  sudo systemctl enable NetworkManager
  sudo systemctl enable sddm
}
enable_services

echo "✅ All done! Reboot and log in via SDDM into Hyprland. Enjoy your rice 🍚"
