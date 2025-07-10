#!/bin/bash

# System services enabling module
enable_services() {
  echo "⚡ Enabling system services..."
  sudo systemctl enable NetworkManager
  sudo systemctl enable sddm
  echo "✅ Services enabled"
} 