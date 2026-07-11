# 🚀 Dotfiles

A collection of configuration files and setup scripts for macOS development environments. Catppuccin Mocha themed 🌸

## Quick Install

```bash
git clone https://github.com/Huckcity/.dotfiles ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

This will:
- Install [Homebrew](https://brew.sh) if missing
- Install all packages from the `Brewfile`
- Symlink config files into your home directory
- Install [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager)

> **Note:** `install.sh` is macOS-specific (requires Homebrew). Linux users should manually symlink the config files.

## What's Inside

### Shell — `.zshrc`

ZSH configuration with:

| Feature | Tool |
|---|---|
| Prompt | [Starship](https://starship.rs) — cross-shell prompt |
| Fuzzy finder | [fzf](https://github.com/junegunn/fzf) with bat preview |
| Smart `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) |
| Directory listing | [eza](https://github.com/eza-community/eza) (modern `ls`) |
| File viewing | [bat](https://github.com/sharkdp/bat) (modern `cat`) |
| File search | [fd](https://github.com/sharkdp/fd) (modern `find`) |
| Text search | [ripgrep](https://github.com/BurntSushi/rg) (modern `grep`) |
| Environment | [direnv](https://direnv.net) |
| Python versions | [pyenv](https://github.com/pyenv/pyenv) |

**Aliases:**

| Alias | Command |
|---|---|
| `ls` | `eza --icons` |
| `ll` | `eza -l --icons --git` |
| `la` | `eza -la --icons --git` |
| `lt` | `eza --tree --icons` |
| `cat` | `bat` |
| `gs` | `git status` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `glog` | `git log --oneline --graph --decorate` |
| `..` / `...` / `....` | `cd ..` / `cd ../..` / `cd ../../..` |
| `tf` | `terraform` |
| `reload` | `source ~/.zshrc` |

**Work & local overrides:**
- `~/.zshrc.work` — sourced if present (for work-specific config)
- `~/.zshrc.local` — sourced if present (for machine-specific overrides)

### Tmux — `.tmux.conf`

| Setting | Value |
|---|---|
| Prefix key | `Ctrl+A` |
| Base index | 1 (windows & panes) |
| Scrollback | 50,000 lines |
| Mouse | Enabled |
| Theme | Catppuccin Mocha |

**Key bindings:**

| Keys | Action |
|---|---|
| `Prefix + r` | Reload config |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Alt + arrows` | Switch panes |
| `Prefix + h/j/k/l` | Switch panes (vim style) |
| `Prefix + H/J/K/L` | Resize panes |
| `Alt + 1-5` | Switch windows |
| `Prefix + [` | Enter copy mode (vi bindings) |

**Plugins** (via TPM):

| Plugin | Purpose |
|---|---|
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save/restore sessions |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save every 15 minutes |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | System clipboard integration |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin Mocha theme |

> Install plugins in tmux: press `Prefix + I` (`Ctrl+A` then `Shift+I`)

### Starship Prompt — `config/starship.toml`

Catppuccin Mocha themed prompt showing:

```
┌─user@host ~/dotfiles main +1
└─➜
```

Modules: username, hostname, directory, git branch/status, Kubernetes context, Docker context, Terraform workspace, AWS profile, Python, Node.js, Go, Rust.

### Eza Theme — `config/eza/theme.yml`

Catppuccin Mocha colour theme for `eza` file listings — colour-coded by file type, permissions, Git status, and more.

### Brewfile — Package Manifest

| Category | Packages |
|---|---|
| **Terminal** | iTerm2, zsh, tmux |
| **Tools** | git, neovim |
| **Modern replacements** | bat, eza, fd, ripgrep, fzf, zoxide, jq, htop, tldr |
| **Prompt** | starship |
| **DevOps** | podman, kubectl, awscli, gh |
| **Dev tools** | direnv, jenv, pyenv |
| **Font** | JetBrains Mono Nerd Font |

## File Structure

```
~/.dotfiles/
├── Brewfile              # Homebrew package manifest
├── install.sh            # macOS installer script
├── .zshrc                # ZSH configuration
├── .tmux.conf            # Tmux configuration
└── config/
    ├── starship.toml     # Starship prompt theme
    └── eza/
        └── theme.yml     # Eza colour theme
```

## Post-Install

1. **New terminal** — opens with zsh + Starship prompt
2. **In tmux** — press `Prefix + I` to install plugins
3. **Restore a session** — tmux-resurrect saves/restores via `Prefix + Ctrl+S` / `Prefix + Ctrl+R`
4. **Work config** — create `~/.zshrc.work` for work-specific overrides
5. **Local overrides** — create `~/.zshrc.local` for machine-specific settings