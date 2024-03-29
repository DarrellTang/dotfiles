-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

nvim_tree.setup {
  log = {
    enable = false,
    truncate = true,
    types = {
      all = true
    },
  },
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = false,
  hijack_cursor = false,
  respect_buf_cwd = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
  view = {
    width = 30,
    side = "left",
    --mappings = {
    --  custom_only = false,
    --  list = {
    --    { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
    --    { key = "h", cb = tree_cb "close_node" },
    --    { key = "v", cb = tree_cb "vsplit" },
    --  },
    --},
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
}

