#!/bin/bash

# Configuration linking module
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
  
  echo "✅ Configuration links created"
} 