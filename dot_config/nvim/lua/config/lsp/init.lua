local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "config.lsp.mason"
require "config.lsp.lsp-zero"
require("config.lsp.handlers").setup()
