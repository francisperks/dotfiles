#!/bin/bash

THEMES_DIR="$HOME/.config/kitty/themes"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"

theme=$(ls "$THEMES_DIR"/*.conf 2>/dev/null | xargs -n 1 basename | wofi --dmenu --prompt="Kitty Theme:")
[ -z "$theme" ] && exit 0

sed -i '/^include.*themes\//d' "$KITTY_CONF"
sed -i "1i include themes/$theme" "$KITTY_CONF"

kitty @ set-colors --all "$THEMES_DIR/$theme" 2>/dev/null
