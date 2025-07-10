#!/bin/bash

# Utility functions and variables module

# Global variables
DEV_MODE=0

# Parse command line arguments
parse_args() {
  for arg in "$@"; do
    if [ "$arg" == "--dev" ]; then
      DEV_MODE=1
      echo "🧪 Dev mode enabled: applying VirtualBox fixes"
    fi
  done
}

# Check if running as root
check_root() {
  if [ "$EUID" -eq 0 ]; then
    echo "❌ This script should not be run as root"
    exit 1
  fi
}

# Check if we're on Arch Linux
check_arch() {
  if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
    echo "⚠️  This script is designed for Arch Linux"
    echo "   Some functionality may not work on other distributions"
  fi
}

# Print section header
print_section() {
  local title="$1"
  echo ""
  echo "─" | tr -d '\n' | head -c 50
  echo ""
  echo "🔧 $title"
  echo "─" | tr -d '\n' | head -c 50
  echo ""
} 