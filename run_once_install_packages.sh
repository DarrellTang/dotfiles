#!/bin/bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask-fonts
brew install coreutils chezmoi curl fzf krew kubectx kubernetes-cli k9s helm neovim openssl screenfetch tfenv tldr tmux lsd yh yq gh jq
brew install --cask alacritty visual-studio-code docker obsidian font-meslo-lg-nerd-font pushplaylabs-sidekick
nvim +PackerSync
