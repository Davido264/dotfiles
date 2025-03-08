local ok, mode = pcall(require, "david.lsp.servers.current")

if not ok then
  mode = "normal"
end

local function filter_available_servers()
  local mason_servers = require("mason-lspconfig").get_available_servers()
  local final = {}

  for _, server in ipairs(require("david.lsp.servers." .. mode).servers) do
    if vim.tbl_contains(mason_servers, server) then
      table.insert(final, server)
    end
  end

  return final
end

return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    setup = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = true,
        ["mason-nvim-dap"] = true,
      }
    },
    config = function(_, opts)
      opts.ensure_installed =
        vim.tbl_deep_extend("force", filter_available_servers(), require("david.lsp.servers." .. mode).tools)
      require("mason-tool-installer").setup(opts)
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        config = true,
        dependencies = {
          "williamboman/mason.nvim"
        }
      },
    },
  },
}
