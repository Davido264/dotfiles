local M = {}

function M.setup()
  require("lazy").load {
    plugins = {
      "typescript-tools.nvim",
    },
  }


  local api = require("typescript-tools.api")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local configs = require "david.lsp.custom_server_configs.tsserver"
  local defaults = {
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
    handlers = {
      ["textDocument/publishDiagnostics"] = api.filter_diagnostics({ 80001 }),
    },
  }

  require("typescript-tools").setup(
    vim.tbl_deep_extend("force", defaults, configs)
  )
end

return M
