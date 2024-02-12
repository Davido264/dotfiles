-- global settings
require "david.disable_builtin"
require "david.sets"
require "david.autocmds"
require "david.commands"
require "david.keymaps"


-- vscode and nvim only settings
if vim.g.vscode then
  require "david.vscode"
else
  -- require "david.pywal"
  -- call this instead of setup(), so ColorScheme aucmds are executed
  -- vim.cmd.colorscheme "pywal"

  local opts = {
    defaults = {
      lazy = true,
    },
  }

  require("lazy").setup("david.plugins", opts)
end

