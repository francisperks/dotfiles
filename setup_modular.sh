#!/bin/bash
set -e

echo "🚀 Starting full Hyprland setup on minimal Arch..."

# Source all modules
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source utility functions first
source "$MODULES_DIR/utils.sh"

# Parse command line arguments
parse_args "$@"

# Run pre-flight checks
check_root
check_arch

# Source all other modules
source "$MODULES_DIR/base_packages.sh"
source "$MODULES_DIR/aur_packages.sh"
source "$MODULES_DIR/config_links.sh"
source "$MODULES_DIR/kitty_themes.sh"
source "$MODULES_DIR/dev_fixes.sh"
source "$MODULES_DIR/services.sh"
source "$MODULES_DIR/sddm_theme.sh"
source "$MODULES_DIR/wallpapers.sh"

# Main execution flow
print_section "Base Packages Installation"
install_base

print_section "AUR Packages Installation"
install_aur

print_section "Configuration Setup"
link_configs

print_section "Kitty Themes Setup"
setup_kitty_themes

print_section "Development Fixes"
apply_dev_fixes

print_section "System Services"
enable_services

print_section "SDDM Theme Setup"
setup_sddm_theme
# Optionally, call customize_sddm for custom theme
# customize_sddm

print_section "Wallpaper Management"
setup_wallpapers

# Final message
echo ""
echo "🎉 All done! Reboot and log in via SDDM into Hyprland. Enjoy your rice 🍚" 