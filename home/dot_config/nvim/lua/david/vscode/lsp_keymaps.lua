local map = require("david.keymaps").gmap

map("n", "K", function ()
  vim.fn.VSCodeNotify "editor.action.showHover"
end)

map("n", "gd", function()
  vim.fn.VSCodeNotify "editor.action.revealDefinition"
end)

map("n", "gs", function()
  vim.fn.VSCodeNotify "editor.action.triggerParameterHints"
end)

map("n", "gr", function()
  vim.fn.VSCodeNotify "editor.action.goToReferences"
end)

map("n", "gD", function()
  vim.fn.VSCodeNotify "editor.action.revealDeclaration"
end)

map("n", "gi", function()
  vim.fn.VSCodeNotify "editor.action.goToImplementation"
end)

map("n", "gt", function()
  vim.fn.VSCodeNotify "editor.action.goToReferences"
end)

map("n", "<leader>vfm", function()
  vim.fn.VSCodeNotify "editor.action.formatDocument"
end)

map("n", "<leader>vrn", function()
  vim.fn.VSCodeNotify "editor.action.rename"
end)

map("n", "<leader>vcd", function()
  vim.fn.VSCodeNotify "workbench.actions.view.problems"
end)

map("n", "<leader>vca", function()
  vim.fn.VSCodeNotify "problems.action.showQuickFixes"
end)

map("n", "gl", function()
  vim.fn.VSCodeNotify "problems.action.open"
end)

map("n", "[d", function()
  vim.fn.VSCodeNotify "editor.action.marker.prevInFiles"
end)

map("n", "]d", function()
  vim.fn.VSCodeNotify "editor.action.marker.nextInFiles"
end)
