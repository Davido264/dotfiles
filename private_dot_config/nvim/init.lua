local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- global settings
require "david.disable_builtin"
require "david.sets"
require "david.autocmds"
require "david.commands"
require "david.keymaps"
require "david.custom_ft"

local opts = {
  defaults = {
    lazy = true,
  },
  git = {
    timeout = 120000,
  },
  ui = {
    border = "rounded",
  },
}

require("lazy").setup("plugins", opts)
