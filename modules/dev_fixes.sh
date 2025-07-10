#!/bin/bash

# Development mode fixes module
apply_dev_fixes() {
  if [ "$DEV_MODE" -eq 1 ]; then
    echo "⚙️ Applying VirtualBox graphics fixes..."
    echo "export LIBGL_ALWAYS_SOFTWARE=1" >> ~/.bash_profile
    echo "export WLR_NO_HARDWARE_CURSORS=1" >> ~/.bash_profile
    echo "✅ VirtualBox graphics fixes applied"
  fi
} 