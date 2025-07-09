#!/bin/bash
set -e

echo "🚀 Starting full Hyprland setup on minimal Arch..."

DEV_MODE=0

# Check for --dev flag
for arg in "$@"
do
  if [ "$arg" == "--dev" ]; then
    DEV_MODE=1
    echo "🧪 Dev mode enabled: using wofi instead of rofi"
  fi
done

# ─────────────────────────────────────────
# 📦 Base packages
# ─────────────────────────────────────────
install_base() {
  if [ $DEV_MODE -eq 1 ]; then
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
  else
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
  fi
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
  for cfg in kitty waybar hypr; do
    target="$HOME/.config/$cfg"
    source="$HOME/dotfiles/$cfg"

    if [ -L "$target" ] || [ -d "$target" ]; then
      echo "⚠️  $cfg already exists, skipping..."
    else
      ln -s "$source" "$target"
      echo "✅ Linked $cfg config"
    fi
  done

  if [ $DEV_MODE -eq 1 ]; then
    target="$HOME/.config/wofi"
    source="$HOME/dotfiles/wofi"
  else
    target="$HOME/.config/rofi"
    source="$HOME/dotfiles/rofi"
  fi

  if [ -L "$target" ] || [ -d "$target" ]; then
    echo "⚠️  $(basename $target) already exists, skipping..."
  else
    ln -s "$source" "$target"
    echo "✅ Linked $(basename $target) config"
  fi
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
