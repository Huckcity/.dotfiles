#!/usr/bin/env bash
# Dotfiles installation script for macOS
# Usage: ./install.sh

set -e

echo "🚀 Setting up your dev environment..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
if [ -f "Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle
else
    echo "⚠️  No Brewfile found, skipping package installation"
fi

# Create symlinks for dotfiles
echo "🔗 Creating symlinks..."

# Define dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Symlink config files
link_file() {
    local src="$1"
    local dest="$2"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    # Backup existing file if it exists and isn't a symlink
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "  Backing up existing $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi
    
    # Create symlink
    ln -sfn "$src" "$dest"
    echo "  ✓ Linked $src → $dest"
}

# Symlink dotfiles
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshrc.work" "$HOME/.zshrc.work"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "📦 Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set up zsh as default shell if it isn't already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

echo "✨ Setup complete! Please restart your terminal or run 'source ~/.zshrc'"
echo "📝 Don't forget to press 'prefix + I' in tmux to install plugins"