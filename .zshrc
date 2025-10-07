# .zshrc - ZSH configuration

# ============================================================================
# Environment Variables
# ============================================================================
export EDITOR="vim"
export VISUAL="vim"
export LANG="en_US.UTF-8"

# Add Homebrew to PATH (Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ============================================================================
# History Configuration
# ============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ============================================================================
# Completion System
# ============================================================================
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Use menu selection for completion
zstyle ':completion:*' menu select

# Better completion for kill command
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================================================
# FZF Configuration
# ============================================================================
if command -v fzf &> /dev/null; then
  # Set up fzf key bindings and fuzzy completion
  source <(fzf --zsh)
  
  # Use fd instead of find for better performance
  if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  
  # Preview files with bat
  if command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
  fi
fi

# ============================================================================
# Zoxide (smart cd)
# ============================================================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# ============================================================================
# Direnv (environment switcher)
# ============================================================================
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# ============================================================================
# Aliases
# ============================================================================
# Modern replacements
if command -v eza &> /dev/null; then
  alias ls="eza --icons"
  alias ll="eza -l --icons --git"
  alias la="eza -la --icons --git"
  alias lt="eza --tree --icons"
fi

if command -v bat &> /dev/null; then
  alias cat="bat"
fi

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# Common shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias tf="terraform"
alias reload="source ~/.zshrc"

# ============================================================================
# Functions
# ============================================================================
# Quick directory creation and navigation
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
kp() {
  ps aux | grep -v grep | grep -i -e "$1" | awk '{print $2}' | xargs kill -9
}

# ============================================================================
# Starship Prompt
# ============================================================================
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================================================
# Work-specific Configuration
# ============================================================================
# Source work-specific config if it exists
[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work

# ============================================================================
# Local Configuration
# ============================================================================
# Source local config if it exists (for machine-specific settings)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local