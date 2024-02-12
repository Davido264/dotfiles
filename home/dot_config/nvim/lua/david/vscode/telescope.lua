local gmap = require("david.keymaps").gmap

gmap("n", "<leader>ff", function()
  vim.fn.VSCodeNotify "workbench.action.quickOpen"
end)

gmap("n", "<leader>gr", function()
  vim.fn.VSCodeNotify "filesExplorer.findInWorkspace"
end)
