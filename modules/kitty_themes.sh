#!/bin/bash

# Kitty themes setup module
setup_kitty_themes() {
  echo -n "🎨 Install extra kitty themes from GitHub? (y/N): "
  read -r install_themes

  if [[ "$install_themes" =~ ^[Yy]$ ]]; then
    git -C "$HOME/.config/kitty-themes" pull 2>/dev/null || \
    git clone https://github.com/dexpota/kitty-themes "$HOME/.config/kitty-themes"

    # Ensure kitty config directory exists
    mkdir -p "$HOME/.config/kitty" 2>/dev/null
    THEME_FILE="$HOME/.config/kitty-themes/themes/Afterglow.conf"
    if [ -f "$THEME_FILE" ]; then
      cp "$THEME_FILE" "$HOME/.config/kitty/theme.conf"
      grep -qxF "include theme.conf" "$HOME/.config/kitty/kitty.conf" || echo "include theme.conf" >> "$HOME/.config/kitty/kitty.conf"
    else
      echo "⚠️  Kitty theme file not found: $THEME_FILE. Skipping theme copy."
    fi

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