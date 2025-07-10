# Modular Setup Scripts

This directory contains modular components of the Hyprland setup script, making it more maintainable and easier to customize.

## Module Structure

### `utils.sh`

- **Purpose**: Common utility functions and global variables
- **Functions**:
  - `parse_args()`: Parse command line arguments (--dev flag)
  - `check_root()`: Ensure script is not run as root
  - `check_arch()`: Verify we're on Arch Linux
  - `print_section()`: Print formatted section headers
- **Variables**: `DEV_MODE`

### `base_packages.sh`

- **Purpose**: Install base system packages via pacman
- **Function**: `install_base()`
- **Packages**: Hyprland, terminal, WM components, audio, fonts, etc.

### `aur_packages.sh`

- **Purpose**: Install AUR packages via yay
- **Function**: `install_aur()`
- **Features**: Auto-installs yay if not present
- **Packages**: Nerd fonts, VS Code, wlogout, neofetch

### `config_links.sh`

- **Purpose**: Create symbolic links for configuration files
- **Function**: `link_configs()`
- **Links**: kitty, wofi, waybar, hypr configs and local binaries

### `kitty_themes.sh`

- **Purpose**: Optional kitty themes installation
- **Function**: `setup_kitty_themes()`
- **Features**: Interactive prompt, GitHub themes repo, theme linking

### `dev_fixes.sh`

- **Purpose**: Apply VirtualBox/VM-specific fixes
- **Function**: `apply_dev_fixes()`
- **Condition**: Only runs when `DEV_MODE=1`
- **Fixes**: Software rendering, cursor issues

### `services.sh`

- **Purpose**: Enable system services
- **Function**: `enable_services()`
- **Services**: NetworkManager, SDDM

## Usage

### Main Script

```bash
# Run full setup
./setup_modular.sh

# Run with dev mode (VirtualBox fixes)
./setup_modular.sh --dev
```

### Individual Modules

You can source and run individual modules:

```bash
source modules/utils.sh
source modules/base_packages.sh
install_base
```

## Benefits of Modular Structure

1. **Maintainability**: Each module has a single responsibility
2. **Reusability**: Modules can be used independently
3. **Testability**: Individual functions can be tested separately
4. **Customization**: Easy to modify specific components
5. **Readability**: Clear separation of concerns
6. **Debugging**: Easier to isolate issues

## Adding New Modules

1. Create a new `.sh` file in the `modules/` directory
2. Define your functions with descriptive names
3. Add the module to `setup_modular.sh`:
   ```bash
   source "$MODULES_DIR/your_module.sh"
   ```
4. Call your function in the main execution flow

## Migration from Original Script

The original `setup.sh` has been preserved. The new `setup_modular.sh` provides the same functionality but in a more organized structure. You can:

- Use `setup_modular.sh` for new installations
- Gradually migrate customizations to individual modules
- Keep `setup.sh` as a backup or reference
