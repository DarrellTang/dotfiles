#!/bin/bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
cp -r ~/.config/nvim.backup/lua/custom ~/.config/nvim/lua
