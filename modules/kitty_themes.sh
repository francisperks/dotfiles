#!/bin/bash

# Kitty themes setup module
setup_kitty_themes() {
  echo "🎨 Installing extra kitty themes from GitHub..."
  git -C "$HOME/.config/kitty-themes" pull 2>/dev/null || \
  git clone https://github.com/dexpota/kitty-themes "$HOME/.config/kitty-themes" || true

  # Ensure kitty config directory exists
  mkdir -p "$HOME/.config/kitty" 2>/dev/null || true
  THEME_FILE="$HOME/.config/kitty-themes/themes/Afterglow.conf"
  if [ -f "$THEME_FILE" ]; then
    cp "$THEME_FILE" "$HOME/.config/kitty/theme.conf" || true
    grep -qxF "include theme.conf" "$HOME/.config/kitty/kitty.conf" || echo "include theme.conf" >> "$HOME/.config/kitty/kitty.conf"
  else
    echo "⚠️  Kitty theme file not found: $THEME_FILE. Skipping theme copy."
  fi

  if [ ! -d "$HOME/.config/kitty/themes" ]; then
    ln -s "$HOME/.config/kitty-themes/themes" "$HOME/.config/kitty/themes" || true
    echo "🔗 Linked kitty themes directory"
  fi

  export KITTY_THEMES_INSTALLED=1
  echo "✅ Kitty themes installed"
} 