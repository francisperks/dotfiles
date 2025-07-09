#!/bin/bash
set -e

echo "🚀 Starting full Hyprland setup on minimal Arch..."

DEV_MODE=0

# Check for --dev flag
for arg in "$@"
do
  if [ "$arg" == "--dev" ]; then
    DEV_MODE=1
    echo "🧪 Dev mode enabled: applying VirtualBox fixes"
  fi
done

# ─────────────────────────────────────────
# 📦 Base packages
# ─────────────────────────────────────────
install_base() {
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
  for cfg in kitty wofi waybar hypr; do
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
  echo -n "🎨 Do you want to install additional kitty themes from GitHub? (y/N): "
  read -r install_themes

  if [[ "$install_themes" =~ ^[Yy]$ ]]; then
    echo "📥 Cloning kitty themes..."
    git clone https://github.com/dexpota/kitty-themes ~/.config/kitty-themes
    cp ~/.config/kitty-themes/themes/Afterglow.conf ~/.config/kitty/theme.conf
    echo "include theme.conf" >> ~/.config/kitty/kitty.conf
    echo "✅ Kitty themes installed"
  else
    echo "🎨 Skipping kitty themes, using default from dotfiles"
  fi
}
setup_kitty_themes

# ─────────────────────────────────────────
# ⚙️ Dev mode fixes for virtual machines
# ─────────────────────────────────────────
apply_dev_fixes() {
  if [ $DEV_MODE -eq 1 ]; then
    echo "export LIBGL_ALWAYS_SOFTWARE=1" >> ~/.bash_profile
    echo "export WLR_NO_HARDWARE_CURSORS=1" >> ~/.bash_profile
    echo "✅ VirtualBox graphics fixes applied"
  fi
}
apply_dev_fixes

# ─────────────────────────────────────────
# ⚡ Enable system services
# ─────────────────────────────────────────
enable_services() {
  sudo systemctl enable NetworkManager
  sudo systemctl enable sddm
}
enable_services

echo "✅ All done! Reboot and log in via SDDM into Hyprland. Enjoy your rice 🍚"
