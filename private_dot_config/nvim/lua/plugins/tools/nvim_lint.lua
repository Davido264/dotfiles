return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    linters = {
      eslint_d = {
        args = {
          "--no-warn-ignored", -- <-- https://github.com/mfussenegger/nvim-lint/issues/462
          "--format",
          "json",
          "--stdin",
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
      },
    },
    events = { "BufWritePost", "BufReadPost" },
    linters_by_ft = {
      javascript = nil,
      typescript = { "eslint_d" },
      go = { "golangcilint" },
      lua = { "selene" },
      -- python = { "pylint" },
      clojure = { "clj-kondo" },
      gitcommit = { "commitlint" },
    },
  },
  config = function(_, opts)
    require("lint").linters_by_ft = opts.linters_by_ft

    vim.api.nvim_create_autocmd(opts.events, {
      callback = function()
        require("lint").try_lint(nil, { ignore_error = true })
      end,
    })
  end,
}
