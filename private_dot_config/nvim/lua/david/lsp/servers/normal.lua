local minimal = require "david.lsp.servers.minimal"

local M = {}

M.servers = vim.tbl_deep_extend("force", minimal.servers, {
  -- Clojure/babashka
  "clojure-lsp",

  -- Dockerfile
  "dockerfile-language-server",

  -- Go
  "gopls",

  -- Java
  "jdtls",

  -- Kotlin
  "kotlin-language-server",

  -- C#
  "omnisharp",

  -- LaTeX
  "texlab",

  -- Javascript/Typescript
  "typescript-language-server",

  -- HTML/CSS/JSON/YAML/Commit
  "css-lsp",
  "html-lsp",
  "json-lsp",
  "yaml-language-server",

  -- Sql
  "sqls",

  -- Rust
  "rust-analyzer",

  ---- Rarely using ----
  -- Dart (Included with dart)
  "dartls",
  --
  -- F#
  -- "fsautocomplete",
  --
  -- Tailwindcss
  -- "tailwindcss-language-server",
  --
  -- Powershell
  -- "powershell-editor-services",
  --
  -- Prisma.js
  -- "prisma-language-server",
  --
  -- Minecraft mcfunction
  -- "spyglassmc-language-server",
  --
  -- PHP
  "intelephense",

  -- Gitlab CI/CD
  "gitlab_ci_ls",

  -- Not managed by lspconfig
  -- "odoo_lsp", -- Odoo language server
  "termux_language_server",
})

M.tools = vim.tbl_deep_extend("force", minimal.tools, {
  -- Clojure/babashka
  "clj-kondo",

  -- Go
  "golangci-lint",
  "goimports",
  "delve",

  -- C#
  "netcoredbg",

  -- Python
  "pylint",
  "black",
  "debugpy",

  -- Javascript/Typescript
  "eslint_d",
  "prettier",
  "node-debug2-adapter",
  "firefox-debug-adapter",

  -- Sql
  "sql-formatter",
})

return M
