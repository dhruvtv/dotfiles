#!/bin/bash
# ============================================================================
# Bootstrap script for new Mac setup
# Usage: curl -fsSL https://raw.githubusercontent.com/dhruvtv/dotfiles/main/bootstrap.sh | bash
# ============================================================================

set -e

echo "🚀 Setting up your Mac..."

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install chezmoi and apply dotfiles
echo "📂 Installing chezmoi and applying dotfiles..."
brew install chezmoi
chezmoi init --apply dhruvtv

# Install all packages from Brewfile
echo "📦 Installing Homebrew packages..."
brew bundle --file=~/.Brewfile

# Install language versions via mise
echo "🔧 Installing language versions via mise..."
eval "$(mise activate bash)"
mise install

echo ""
echo "✅ Setup complete! Restart your terminal to see the new setup."
echo ""
echo "What's installed:"
echo "  Shell:    zsh + Starship prompt"
echo "  Theme:    Catppuccin Mocha"
echo "  Font:     JetBrains Mono Nerd Font"
echo "  Terminal: Ghostty"
echo "  Python:   uv + ruff (Astral)"
echo "  Node:     managed by mise"
echo "  Go:       managed by mise"
echo "  Git:      delta for diffs"
echo "  CLI:      eza, bat, fd, rg, zoxide, fzf, lazygit, just"
