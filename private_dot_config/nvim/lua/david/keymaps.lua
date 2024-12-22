local M = {}

function M.gmap(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.bmap(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { buffer = true, silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.gmap("n", "<F1>", "<Esc>")
M.gmap("i", "<F1>", "<Esc>")
M.gmap("v", "J", ":m '>+1<CR>gv=gv")
M.gmap("v", "K", ":m '<-2<CR>gv=gv")
M.gmap("n", "Q", "<nop>")

if vim.g.vscode then
  M.gmap("n", "<leader>FF", function()
    vim.fn.VSCodeNotify "workbench.action.toggleSidebarVisibility"
  end)
end

-- Copy path of the opened file
M.gmap("n", "<leader>pwd", '<cmd>let @*=expand("%")<CR>')

return M
