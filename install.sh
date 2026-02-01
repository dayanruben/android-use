#!/bin/bash
# Agent Autonomous Installation Script for android-use
# This script can be run by AI agents to automatically set up the skill

set -e

REPO_URL="https://github.com/iurysza/android-use.git"
INSTALL_DIR="${HOME}/.config/opencode/skill/android-use"
SCRIPT_NAME="android-use"

echo "=== android-use Agent Installation ==="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check for git
if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed"
    exit 1
fi

# Check for bun
if ! command -v bun &> /dev/null; then
    echo "Error: bun is required but not installed"
    echo "Install from: https://bun.sh"
    exit 1
fi

# Check for adb
if ! command -v adb &> /dev/null; then
    echo "Warning: adb not found. You'll need Android Platform Tools installed."
    echo "Download from: https://developer.android.com/studio/releases/platform-tools"
fi

echo "✓ Prerequisites met"
echo ""

# Create skills directory
echo "Creating skills directory..."
mkdir -p "$(dirname "$INSTALL_DIR")"
echo ""

# Clone repository
echo "Cloning repository..."
if [ -d "$INSTALL_DIR" ]; then
    echo "Directory exists, pulling latest..."
    cd "$INSTALL_DIR"
    git pull
else
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi
echo "✓ Repository cloned/updated"
echo ""

# Install dependencies
echo "Installing dependencies..."
bun install
echo "✓ Dependencies installed"
echo ""

# Build project
echo "Building project..."
bun run build
echo "✓ Build complete"
echo ""

# Create wrapper script
echo "Creating wrapper script..."
ln -sf "$INSTALL_DIR/dist/index.js" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "✓ Wrapper script created"
echo ""

# Add to PATH if not already there
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_CONFIG" 2>/dev/null; then
        echo "Adding to PATH in $SHELL_CONFIG..."
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_CONFIG"
        echo "✓ Added to PATH"
        echo ""
        echo "Note: Run 'source $SHELL_CONFIG' or restart your shell to use 'android-use' directly"
    else
        echo "✓ Already in PATH"
    fi
else
    echo "Could not find shell config file. Add this to your shell config:"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""

# Verify installation
echo "Verifying installation..."
if "$INSTALL_DIR/$SCRIPT_NAME" check-device; then
    echo ""
    echo "=== Installation Complete ==="
    echo ""
    echo "Usage:"
    echo "  Direct: $INSTALL_DIR/android-use <command>"
    echo "  Or if in PATH: android-use <command>"
    echo ""
    echo "Quick start:"
    echo "  android-use check-device     # List devices"
    echo "  android-use get-screen       # Get UI state"
    echo "  android-use tap 540 960      # Tap screen"
    echo ""
    echo "See README.md for more examples"
else
    echo ""
    echo "Installation complete, but device check failed."
    echo "This is expected if no Android device is connected."
    echo ""
    echo "To use: $INSTALL_DIR/android-use <command>"
fi
