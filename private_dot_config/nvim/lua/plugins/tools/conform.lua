return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>vfm",
      function()
        require("conform").format { async = true, lsp_format = "fallback" }
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters = {
      alejandra = {
        command = "alejandra",
        args = { "-qq" },
      },
      yml = {
        env = {
          YAMLFIX_SEQUENCE_STYLE = "block_style",
        },
      },
    },
    formatters_by_ft = {
      sh = { "shfmt" },
      bash = { "shfmt" },
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      go = { "goimports", lsp_format = "last" },
      sql = { "sql_formatter" },
    },
  },
}
