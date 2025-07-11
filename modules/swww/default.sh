#!/bin/bash
set -e

# Start the daemon if it's not already running
pgrep swww-daemon >/dev/null || swww-daemon &

# Give it a moment to initialize
sleep 0.5

# Set the wallpaper
swww img "$HOME/Pictures/wallpapers/default.jpg" --transition-type any
