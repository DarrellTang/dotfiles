# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with [chezmoi](https://www.chezmoi.io/). The repository contains configuration files for a macOS development environment with a focus on terminal-based workflows.

## Architecture

### Configuration Management
- **chezmoi**: Primary dotfiles manager with templates in `dot_*` files that map to `.*` files in the home directory
- **External dependencies**: Managed via `dot_chezmoiexternal.toml` for oh-my-zsh, zsh-syntax-highlighting, and powerlevel10k theme
- **Installation scripts**: `run_once_*` scripts handle initial package installation and configuration

### Key Components
- **Shell**: Zsh with oh-my-zsh framework and powerlevel10k theme
- **Terminal**: Alacritty with custom configuration
- **Editor**: Neovim with extensive Lua-based configuration using Packer plugin manager
- **Terminal multiplexer**: tmux with custom configuration
- **Window management**: AeroSpace window manager

### Neovim Configuration Structure
- **Plugin management**: Packer.nvim with auto-installation and sync
- **LSP**: lsp-zero.nvim with Mason for language server management
- **Completion**: nvim-cmp with multiple sources
- **File navigation**: Telescope and nvim-tree
- **Git integration**: fugitive, gitsigns, and octo.nvim for GitHub

## Common Commands

### Initial Setup
```bash
# Install packages and tools
./run_once_01_install_packages.sh

# Configure Neovim (backs up existing config)
./run_once_02_config_nvim.sh
```

### Chezmoi Operations
```bash
# Apply dotfiles to home directory
chezmoi apply

# Edit a config file through chezmoi
chezmoi edit ~/.zshrc

# Update external dependencies
chezmoi update
```

### Neovim Plugin Management
```bash
# Sync plugins (auto-triggered on plugins.lua save)
nvim +PackerSync

# Install/update plugins
nvim +PackerInstall
nvim +PackerUpdate
```

## Environment Setup Notes

- Shell automatically starts tmux session named "workspace"
- Zsh plugins include git, kubectl, colored-man-pages, helm, terraform, golang, fzf
- Custom aliases for kubectl (k, kns, kc, kd, kg), ls (lsd), and tmux/ssh with proper TERM settings
- PATH includes Go, Pulumi, Krew, and local bins
- Default editor set to nvim