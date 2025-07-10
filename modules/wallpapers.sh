#!/bin/bash

# Wallpaper management module
setup_wallpapers() {
  echo "🖼️ Setting up wallpaper management..."
  
  # Install wallpaper-related packages
  yay -S --noconfirm \
    feh \
    nitrogen \
    variety \
    wallutils \
    pywal
  
  # Create wallpaper directories
  mkdir -p "$HOME/Pictures/Wallpapers"
  mkdir -p "$HOME/.config/variety"
  
  # Download some high-quality wallpapers
  download_wallpapers
  
  # Setup variety configuration
  setup_variety_config
  
  echo "✅ Wallpaper management configured"
}

download_wallpapers() {
  echo "📥 Downloading sample wallpapers..."
  
  # Create a script to download wallpapers
  cat > "$HOME/.local/bin/download-wallpapers.sh" <<'EOF'
#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Download some beautiful wallpapers
cd "$WALLPAPER_DIR"

# Download from Unsplash (you can customize these URLs)
curl -L "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop" -o "mountain-sunset.jpg"
curl -L "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop&sat=-50" -o "mountain-blue.jpg"
curl -L "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop&sat=50" -o "mountain-warm.jpg"

echo "✅ Wallpapers downloaded to $WALLPAPER_DIR"
EOF

  chmod +x "$HOME/.local/bin/download-wallpapers.sh"
  
  # Run the download script
  "$HOME/.local/bin/download-wallpapers.sh"
}

setup_variety_config() {
  echo "⚙️ Configuring Variety wallpaper changer..."
  
  # Create variety config
  cat > "$HOME/.config/variety/variety.conf" <<EOF
[Variety]
change_interval=1800
download_interval=3600
favorites_folder=$HOME/Pictures/Wallpapers
wallpaper_folder=$HOME/Pictures/Wallpapers
auto_change=true
notify_change=true
start_in_tray=true
EOF
} 