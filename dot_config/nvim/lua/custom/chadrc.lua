-- This is an example chadrc file , its supposed to be placed in /lua/custom/

local M = {}

M.options = {
  user = function ()
    vim.opt.relativenumber = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.o.incsearch = true
    vim.o.foldenable = false
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.autoread = true
  end
}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "tokyonight",
}

-- Install plugins
local userPlugins = require "custom.plugins" -- path to table

M.plugins = {
   user = userPlugins,
   options = {
      lspconfig = {
         setup_lspconf = "custom.lspconfig",
      },
   },
}

-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event','cmd' fields)
-- see: https://github.com/wbthomason/packer.nvim
-- https://nvchad.github.io/config/walkthrough

return M
