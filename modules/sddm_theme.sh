#!/bin/bash

# SDDM theme installation and configuration module
setup_sddm_theme() {
  echo "🎨 Setting up SDDM theme..."
  
  # Install SDDM theme packages
  yay -S --noconfirm \
    sddm-theme-sugar-candy \
    sddm-theme-corners \
    sddm-theme-astronaut
  
  # Create SDDM config directory if it doesn't exist
  sudo mkdir -p /etc/sddm.conf.d/
  
  # Configure SDDM with a modern theme
  sudo tee /etc/sddm.conf.d/theme.conf > /dev/null <<EOF
[Theme]
Current=sugar-candy
EOF

  # Alternative: Use corners theme for a more minimal look
  # sudo tee /etc/sddm.conf.d/theme.conf > /dev/null <<EOF
  # [Theme]
  # Current=corners
  # EOF

  echo "✅ SDDM theme configured"
}

# Apply custom SDDM theme settings
customize_sddm() {
  echo "🎨 Customizing SDDM appearance..."
  
  # Create custom theme directory
  sudo mkdir -p /usr/share/sddm/themes/custom-sugar-candy
  
  # Copy the sugar-candy theme as base
  sudo cp -r /usr/share/sddm/themes/sugar-candy/* /usr/share/sddm/themes/custom-sugar-candy/
  
  # Customize the theme configuration
  sudo tee /usr/share/sddm/themes/custom-sugar-candy/theme.conf > /dev/null <<EOF
[General]
background=background.jpg
type=image
color=#2e3440
fontSize=10
forceRightToLeft=0
needsFullUserModel=false

[Blur]
fullScreen=true
lockScreen=true

[Code]
alignment=left
color=#d8dee9
fontName=JetBrains Mono
fontSize=12

[Colors]
accent=#5e81ac
background=#2e3440
error=#bf616a
success=#a3be8c
warning=#ebcb8b

[Desktop Entry]
Name=Custom Sugar Candy
Comment=Customized Sugar Candy theme for SDDM
EOF

  # Update SDDM config to use custom theme
  sudo tee /etc/sddm.conf.d/theme.conf > /dev/null <<EOF
[Theme]
Current=custom-sugar-candy
EOF

  echo "✅ Custom SDDM theme applied"
} 