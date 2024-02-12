local gmap = require("david.keymaps").gmap

gmap("n", "<leader>a", function()
  vim.fn.VSCodeNotify "vscode-harpoon.addEditor"
end)

gmap("n", "<C-e>", function()
  vim.fn.VSCodeNotify "vscode-harpoon.editEditors"
end)

gmap("n", "<C-j>", function()
  vim.fn.VSCodeNotify "vscode-harpoon.gotoEditor1"
end)

gmap("n", "<C-k>", function()
  vim.fn.VSCodeNotify "vscode-harpoon.gotoEditor2"
end)

gmap("n", "<C-l>", function()
  vim.fn.VSCodeNotify "vscode-harpoon.gotoEditor3"
end)

gmap("n", "<C-;>", function()
  vim.fn.VSCodeNotify "vscode-harpoon.gotoEditor4"
end)
