#!/bin/bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask-fonts
brew install coreutils chezmoi curl fzf krew kubectx kubernetes-cli k9s helm nvim openssl screenfetch tfenv tldr tmux exa yh yq
brew install --cask alacritty visual-studio-code slack docker workflowy font-meslo-lg-nerd-font
nvim +PackerSync
