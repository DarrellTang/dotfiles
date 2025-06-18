# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Quick Start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install
```

## What's Included

- **Shell**: Zsh with oh-my-zsh, powerlevel10k theme, syntax highlighting
- **Terminal**: Alacritty configuration
- **Editor**: Neovim with LSP, completion, and plugin management
- **Tools**: tmux, git, kubectl aliases and configurations
- **Window Manager**: AeroSpace configuration

## Installation

The `./install` script will:
1. Install Homebrew and essential packages
2. Set up oh-my-zsh with powerlevel10k theme
3. Link all dotfiles to your home directory
4. Configure Neovim with plugins

Run `./install --help` for additional options.