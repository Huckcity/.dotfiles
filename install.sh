#!/usr/bin/env bash
# Dotfiles installation script for macOS and Linux
# Usage: ./install.sh

set -e

echo "🚀 Setting up your dev environment..."

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos";;
        Linux*)     echo "linux";;
        *)          echo "unknown";;
    esac
}

OS=$(detect_os)

if [ "$OS" = "unknown" ]; then
    echo "❌ Unsupported operating system"
    exit 1
fi

echo "📍 Detected OS: $OS"

# Install packages based on OS
if [ "$OS" = "macos" ]; then
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
elif [ "$OS" = "linux" ]; then
    # Try to use Homebrew if available, otherwise use native package manager
    if command -v brew &> /dev/null; then
        echo "📦 Using Homebrew for package installation..."
        if [ -f "Brewfile" ]; then
            brew bundle
        fi
    else
        echo "📦 Installing packages using native package manager..."
        
        # Detect Linux package manager
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y \
                zsh tmux git curl wget \
                neovim bat fd-find ripgrep fzf \
                jq htop direnv \
                podman awscli gh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y \
                zsh tmux git curl wget \
                neovim bat fd-find ripgrep fzf \
                jq htop direnv \
                podman awscli gh
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm \
                zsh tmux git curl wget \
                neovim bat fd ripgrep fzf \
                jq htop direnv \
                podman aws-cli github-cli
        else
            echo "⚠️  No supported package manager found (apt, dnf, or pacman)"
            echo "⚠️  Please install packages manually"
        fi
        
        # Install packages not in standard repos
        echo "📦 Installing additional tools..."
        
        # Install eza (modern ls replacement)
        if ! command -v eza &> /dev/null; then
            echo "  Installing eza..."
            if command -v cargo &> /dev/null; then
                cargo install eza
            else
                echo "  ⚠️  cargo not found, skipping eza. Install Rust or download from https://github.com/eza-community/eza"
            fi
        fi
        
        # Install zoxide (smart cd)
        if ! command -v zoxide &> /dev/null; then
            echo "  Installing zoxide..."
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        fi
        
        # Install starship prompt
        if ! command -v starship &> /dev/null; then
            echo "  Installing starship..."
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi
        
        # Install pyenv
        if ! command -v pyenv &> /dev/null; then
            echo "  Installing pyenv..."
            curl https://pyenv.run | bash
        fi
    fi
fi

# Create symlinks for dotfiles
echo "🔗 Creating symlinks..."

# Define dotfiles directory (absolute path to where this script is located)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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