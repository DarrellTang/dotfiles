# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot). The repository contains configuration files for a macOS development environment with a focus on terminal-based workflows.

## Architecture

### Configuration Management
- **dotbot**: Lightweight dotfiles bootstrapper using YAML configuration
- **Git submodule**: Dotbot included as submodule for self-contained setup
- **Single command setup**: `./install` handles complete environment configuration

### Key Components
- **Shell**: Zsh with oh-my-zsh framework and powerlevel10k theme
- **Terminal**: Alacritty with custom configuration
- **Editor**: Neovim with LazyVim for modern IDE experience
- **Terminal multiplexer**: tmux with custom configuration
- **Window management**: AeroSpace window manager

### Neovim Configuration Structure
- **Plugin management**: LazyVim with lazy.nvim for modern plugin management
- **LSP**: Built-in LSP support with Mason for language server management
- **Pre-configured IDE**: Comprehensive setup with sensible defaults
- **File navigation**: Telescope, neo-tree, and other modern tools
- **Git integration**: Built-in git support with lazygit integration

## Common Commands

### Initial Setup
```bash
# Clone repository and run complete setup
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install
```

### Dotbot Operations
```bash
# Run full installation/update
./install

# Run specific sections only
./install --only link
./install --only shell
```

### Neovim Plugin Management
```bash
# LazyVim auto-installs plugins on first startup
nvim

# Update plugins (within Neovim)
:Lazy update

# Check plugin status
:Lazy
```

## Installation Process

The `./install` script performs:
1. **Package installation**: Homebrew and essential CLI tools
2. **Shell setup**: oh-my-zsh, powerlevel10k theme, zsh-syntax-highlighting
3. **Symlink creation**: Links all dotfiles to home directory
4. **Directory creation**: Creates necessary directories
5. **Neovim configuration**: Sets up LazyVim (plugins auto-install on first run)

## Environment Setup Notes

- Shell automatically starts tmux session named "workspace"
- Zsh plugins include git, kubectl, colored-man-pages, helm, terraform, golang, fzf
- Custom aliases for kubectl (k, kns, kc, kd, kg), ls (lsd), and tmux/ssh with proper TERM settings
- PATH includes Go, Pulumi, Krew, and local bins
- Default editor set to nvim