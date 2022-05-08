#!/bin/bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
cp -r ~/.config/nvim.backup/lua/custom ~/.config/nvim/lua
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask-fonts
brew install coreutils chezmoi curl fzf krew kubectx kubernetes-cli k9s helm nvim openssl screenfetch tfenv tldr tmux exa
brew install --cask alacritty visual-studio-code slack docker workflowy font-meslo-lg-nerd-font
nvim +PackerSync
