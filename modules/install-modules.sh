#!/bin/bash
set -e

MOD_DIR="$HOME/dotfiles/modules"

declare -a MODULES=(
  "hyprlock-idle"
  "swww"
  "rofi"
)

for mod in "${MODULES[@]}"; do
  SETUP="$MOD_DIR/$mod/setup.sh"
  if [ -f "$SETUP" ]; then
    echo "📦 Installing module: $mod"
    chmod +x "$SETUP"
    "$SETUP"
  else
    echo "⚠️  Skipping: $mod (no setup.sh found)"
  fi
done
