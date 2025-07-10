#!/bin/bash

# Kitty themes setup module
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