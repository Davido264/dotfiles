local M = {}

function M.capabilities()
  local cap = require("cmp_nvim_lsp").default_capabilities()
  cap.textDocument.completion.completionItem.snippetSupport = true
  return cap
end

function M.setup_and_run_tailwind()
  local nvim_lsp = require "lspconfig"
  local utils = require "david.utils"

  nvim_lsp.tailwindcss.setup {
    on_attach = utils.lsp_on_attach,
    single_file_support = true,
    capabilities = utils.capabilities(),
  }
end

return M
