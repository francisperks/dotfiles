#!/bin/bash
set -e

echo "🚀 Starting full Hyprland setup on minimal Arch..."

DEV_MODE=0

# ─────────────────────────────────────────
# 🔍 Check for --dev flag
# ─────────────────────────────────────────
for arg in "$@"; do
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
# 📦 AUR (yay + extras)
# ─────────────────────────────────────────
install_aur() {
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
}
install_aur


# ─────────────────────────────────────────
# 🔗 Dotfiles symlinks
# ─────────────────────────────────────────
link_configs() {
  echo "🔗 Linking config directories..."
  for cfg in kitty wofi waybar hypr; do
    ln -sf "$PWD/config/$cfg" "$HOME/.config/$cfg"
    echo "✅ Linked $cfg"
  done

  mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"

  ln -sf "$PWD/local/bin/kitty-theme-picker.sh" "$HOME/.local/bin/kitty-theme-picker.sh"
  chmod +x "$HOME/.local/bin/kitty-theme-picker.sh"

  if [ -f "$PWD/local/bin/kitty-theme-switch.sh" ]; then
    ln -sf "$PWD/local/bin/kitty-theme-switch.sh" "$HOME/.local/bin/kitty-theme-switch.sh"
    chmod +x "$HOME/.local/bin/kitty-theme-switch.sh"
    echo "✅ Linked and made kitty-theme-switch.sh executable"
  else
    echo "⚠️  Skipping kitty-theme-switch.sh: source file not found"
  fi

  ln -sf "$PWD/share/applications/kitty-theme-picker.desktop" "$HOME/.local/share/applications/kitty-theme-picker.desktop"
}
link_configs


# ─────────────────────────────────────────
# 🎨 Optional: clone kitty-themes repo
# ─────────────────────────────────────────
setup_kitty_themes() {
  echo -n "🎨 Install extra kitty themes from GitHub? (y/N): "
  read -r install_themes

  if [[ "$install_themes" =~ ^[Yy]$ ]]; then
    git -C "$HOME/.config/kitty-themes" pull 2>/dev/null || \
    git clone https://github.com/dexpota/kitty-themes "$HOME/.config/kitty-themes"

    mkdir -p "$HOME/.config/kitty"
    cp "$HOME/.config/kitty-themes/themes/Afterglow.conf" "$HOME/.config/kitty/theme.conf"
    grep -qxF "include theme.conf" "$HOME/.config/kitty/kitty.conf" || echo "include theme.conf" >> "$HOME/.config/kitty/kitty.conf"

    if [ ! -d "$HOME/.config/kitty/themes" ]; then
      ln -s "$HOME/.config/kitty-themes/themes" "$HOME/.config/kitty/themes"
      echo "🔗 Linked kitty themes directory"
    fi

    export KITTY_THEMES_INSTALLED=1
    echo "✅ Kitty themes installed"
  else
    export KITTY_THEMES_INSTALLED=0
    echo "🎨 Skipping kitty themes"
  fi
}
setup_kitty_themes

# ─────────────────────────────────────────
# ⚙️ Dev mode VM fixes
# ─────────────────────────────────────────
apply_dev_fixes() {
  if [ "$DEV_MODE" -eq 1 ]; then
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
  echo "✅ Services enabled"
}
enable_services

# ─────────────────────────────────────────
# ✅ Done
# ─────────────────────────────────────────
echo "🎉 All done! Reboot and log in via SDDM into Hyprland. Enjoy your rice 🍚"
