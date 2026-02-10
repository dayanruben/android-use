#!/bin/bash
# Agent Autonomous Installation Script for android-use
# This script can be run by AI agents to automatically set up the skill
#
# Usage: ./install.sh [OPTIONS]
#
# Options:
#   --claude-code, -c     Install for Claude Code environment
#   --agent=NAME          Install for specific agent (claude-code, opencode, etc.)
#   --non-interactive, -n Run without interactive prompts
#   --help, -h            Show this help message

set -e

# Parse command line arguments
AGENT=""
NON_INTERACTIVE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --claude-code|-c)
      AGENT="claude-code"
      shift
      ;;
    --agent=*)
      AGENT="${1#*=}"
      shift
      ;;
    --agent)
      AGENT="$2"
      shift 2
      ;;
    --non-interactive|-n)
      NON_INTERACTIVE=true
      shift
      ;;
    --help|-h)
      echo "Usage: ./install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --claude-code, -c     Install for Claude Code environment"
      echo "  --agent=NAME          Install for specific agent (claude-code, opencode, etc.)"
      echo "  --non-interactive, -n Run without interactive prompts"
      echo "  --help, -h            Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

REPO_URL="${ANDROID_USE_REPO_URL:-https://github.com/iurysza/android-use.git}"
SCRIPT_NAME="android-use"
SKIP_DEPENDENCIES_INSTALL="${ANDROID_USE_SKIP_DEPENDENCIES_INSTALL:-0}"
SKIP_BUILD="${ANDROID_USE_SKIP_BUILD:-0}"
SKIP_VERIFY="${ANDROID_USE_SKIP_VERIFY:-0}"

is_truthy() {
  case "$1" in
    1|true|TRUE|yes|YES|on|ON) return 0 ;;
    *) return 1 ;;
  esac
}

# Set skill directory based on agent
if [ "$AGENT" = "claude-code" ]; then
  SKILL_DIR="${HOME}/.claude/skills/android-use"
else
  SKILL_DIR="${HOME}/.config/opencode/skill/android-use"
fi

REPO_DIR="$SKILL_DIR/repo"
SCRIPTS_DIR="$SKILL_DIR/scripts"
REFERENCES_DIR="$SKILL_DIR/references"
ASSETS_DIR="$SKILL_DIR/assets"
WRAPPER_SCRIPT="$SCRIPTS_DIR/$SCRIPT_NAME"

echo "=== android-use Agent Installation ==="
if [ -n "$AGENT" ]; then
  echo "Agent: $AGENT"
  echo "Install path: $SKILL_DIR"
fi
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
mkdir -p "$SKILL_DIR"
echo ""

# Clone repository
echo "Cloning repository..."
if [ -d "$REPO_DIR/.git" ]; then
    echo "Directory exists, pulling latest..."
    cd "$REPO_DIR"
    git pull
else
    # If old structure exists without repo subfolder, backup and re-clone
    if [ -d "$SKILL_DIR/.git" ]; then
        echo "Migrating from old structure..."
        mv "$SKILL_DIR" "${SKILL_DIR}.backup.$(date +%s)"
        mkdir -p "$SKILL_DIR"
    fi
    git clone "$REPO_URL" "$REPO_DIR"
fi
echo "✓ Repository cloned/updated"
echo ""

# Install dependencies
echo "Installing dependencies..."
cd "$REPO_DIR"
if is_truthy "$SKIP_DEPENDENCIES_INSTALL"; then
    echo "Skipping dependency install (ANDROID_USE_SKIP_DEPENDENCIES_INSTALL=$SKIP_DEPENDENCIES_INSTALL)"
else
    bun install
fi
echo "✓ Dependencies installed"
echo ""

# Build project
echo "Building project..."
if is_truthy "$SKIP_BUILD"; then
    echo "Skipping build (ANDROID_USE_SKIP_BUILD=$SKIP_BUILD)"
else
    bun run build
fi
echo "✓ Build complete"
echo ""

# Sync skill files to canonical folders
echo "Syncing skill files..."
mkdir -p "$SCRIPTS_DIR" "$REFERENCES_DIR" "$ASSETS_DIR"

cp "$REPO_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"

if [ -d "$REPO_DIR/references" ]; then
    cp -R "$REPO_DIR/references/." "$REFERENCES_DIR/"
elif [ -d "$REPO_DIR/examples" ]; then
    cp -R "$REPO_DIR/examples/." "$REFERENCES_DIR/"
fi

if [ -d "$REPO_DIR/assets" ]; then
    cp -R "$REPO_DIR/assets/." "$ASSETS_DIR/"
fi

echo "✓ SKILL.md, references, and assets synced"
echo ""

# Create wrapper script in scripts folder
echo "Creating wrapper script..."
cat > "$WRAPPER_SCRIPT" << EOF
#!/bin/bash
exec "$REPO_DIR/dist/index.js" "\$@"
EOF
chmod +x "$WRAPPER_SCRIPT"
ln -sf "$WRAPPER_SCRIPT" "$SKILL_DIR/$SCRIPT_NAME"
echo "✓ Wrapper script created"
echo ""

# Add to PATH if not already there
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

PATH_ENTRY="$SCRIPTS_DIR"

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -Fq "$PATH_ENTRY" "$SHELL_CONFIG" 2>/dev/null; then
        echo "Adding to PATH in $SHELL_CONFIG..."
        echo "export PATH=\"$PATH_ENTRY:\$PATH\"" >> "$SHELL_CONFIG"
        echo "✓ Added to PATH"
        echo ""
        echo "Note: Run 'source $SHELL_CONFIG' or restart your shell to use 'android-use' directly"
    else
        echo "✓ Already in PATH"
    fi
else
    echo "Could not find shell config file. Add this to your shell config:"
    echo "export PATH=\"$PATH_ENTRY:\$PATH\""
fi

echo ""

# Verify installation
echo "Verifying installation..."
INSTALL_VERIFIED=true

if is_truthy "$SKIP_VERIFY"; then
    echo "Skipping device verification (ANDROID_USE_SKIP_VERIFY=$SKIP_VERIFY)"
else
    if "$WRAPPER_SCRIPT" check-device; then
        INSTALL_VERIFIED=true
    else
        INSTALL_VERIFIED=false
    fi
fi

if [ "$INSTALL_VERIFIED" = true ]; then
    echo ""
    echo "=== Installation Complete ==="
    echo ""
    echo "Structure:"
    echo "  $SKILL_DIR/"
    echo "  ├── SKILL.md             # Skill metadata + instructions"
    echo "  ├── scripts/"
    echo "  │   └── android-use      # CLI wrapper"
    echo "  ├── references/          # Docs loaded into context"
    echo "  ├── assets/              # Non-context skill assets"
    echo "  ├── android-use          # Compatibility symlink"
    echo "  └── repo/                # Git repository"
    echo ""
    echo "Usage:"
    echo "  Direct: $SKILL_DIR/scripts/android-use <command>"
    echo "  Compat: $SKILL_DIR/android-use <command>"
    echo "  Or if in PATH: android-use <command>"
    echo ""
    echo "Quick start:"
    echo "  android-use check-device     # List devices"
    echo "  android-use get-screen       # Get UI state"
    echo "  android-use tap 540 960      # Tap screen"
    echo ""
    echo "See SKILL.md for more examples"
else
    echo ""
    echo "Installation complete, but device check failed."
    echo "This is expected if no Android device is connected."
    echo ""
    echo "Structure created at: $SKILL_DIR/"
    echo "To use: $SKILL_DIR/scripts/android-use <command>"
fi
