#!/bin/bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install coreutils curl exa fzf krew kubectx kubernetes-cli kubernetes-helm nvim openssl screenfetch terraform tfenv tldr tmux unzip zsh 
brew install --cask alacritty lens virtualbox visual-studio-code slack workflowy 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

