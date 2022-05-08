#!/bin/bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
cp -r ~/.config/nvim.backup/lua ~/.config/nvim/lua
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install coreutils chezmoi curl fzf krew kubectx kubernetes-cli kubernetes-helm nvim openssl screenfetch tfenv terraform tldr tmux unzip zsh 
brew install --cask alacritty lens visual-studio-code slack workflowy 


