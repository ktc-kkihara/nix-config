#!/usr/bin/env bash

# KINTO FACTORY 開発環境 - Nix 初期セットアップスクリプト
# Usage: ./scripts/install.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Configuration
REPO_PATH="${HOME}/ghq/github.com/ktc-kkihara/nix-config"
HOSTNAME="P-LMD0551"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  KINTO FACTORY 開発環境 - Nix セットアップ                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is for macOS only"
fi

# Check architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    warn "This configuration is optimized for Apple Silicon (arm64)"
    warn "Current architecture: $ARCH"
fi

# Step 1: Check if Nix is installed
info "Checking Nix installation..."
if command -v nix &> /dev/null; then
    NIX_VERSION=$(nix --version 2>/dev/null || echo "unknown")
    success "Nix is installed: $NIX_VERSION"
else
    info "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    success "Nix installed"

    info "Please restart your terminal and run this script again"
    exit 0
fi

# Step 2: Check if flakes are enabled
info "Checking Nix flakes support..."
if nix flake --help &> /dev/null; then
    success "Nix flakes are enabled"
else
    error "Nix flakes are not enabled. Please enable experimental features."
fi

# Step 3: Check repository path
info "Checking repository path..."
if [[ ! -d "$REPO_PATH" ]]; then
    error "Repository not found at $REPO_PATH"
fi
success "Repository found at $REPO_PATH"

# Step 4: Check flake.nix exists
info "Checking flake.nix..."
if [[ ! -f "$REPO_PATH/flake.nix" ]]; then
    error "flake.nix not found in $REPO_PATH"
fi
success "flake.nix found"

# Step 5: Build and check configuration
info "Running 'nix flake check'..."
cd "$REPO_PATH"
if nix flake check 2>&1; then
    success "Flake check passed"
else
    warn "Flake check had warnings (this might be okay)"
fi

# Step 6: Build the configuration (dry run)
info "Building configuration (dry run)..."
if nix build ".#darwinConfigurations.${HOSTNAME}.system" --dry-run 2>&1; then
    success "Dry run build successful"
else
    error "Dry run build failed"
fi

# Step 7: Confirm before applying
echo ""
warn "This will apply the Nix configuration to your system."
warn "The following changes will be made:"
echo "  - System packages will be installed via Nix"
echo "  - Homebrew packages will be managed declaratively"
echo "  - Shell configuration will be updated"
echo "  - macOS system preferences will be modified"
echo ""
read -p "Do you want to continue? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Aborted by user"
    exit 0
fi

# Step 8: Apply the configuration
info "Applying configuration..."
cd "$REPO_PATH"

# First time setup requires bootstrapping nix-darwin
if ! command -v darwin-rebuild &> /dev/null; then
    info "Bootstrapping nix-darwin..."
    nix run nix-darwin -- switch --flake ".#${HOSTNAME}"
else
    darwin-rebuild switch --flake ".#${HOSTNAME}"
fi

success "Configuration applied successfully!"

# Step 9: Post-installation message
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  セットアップ完了！                                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "次のステップ:"
echo ""
echo "  1. ターミナルを再起動してください"
echo "     または: source ~/.zshrc"
echo ""
echo "  2. 設定を更新するには:"
echo "     make rebuild"
echo "     または: rebuild (エイリアス)"
echo ""
echo "  3. パッケージを更新するには:"
echo "     make update"
echo ""
echo "  4. その他のコマンドは:"
echo "     make help"
echo ""
echo "  5. Rust のセットアップ (初回のみ):"
echo "     rustup default stable"
echo ""
success "Happy coding! 🚀"
