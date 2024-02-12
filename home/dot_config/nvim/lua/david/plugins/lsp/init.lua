return {
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      setup = {
        ["jdtls"] = require("david.plugins.lsp.jdtls").setup,
        ["eslint"] = false,
      },
      servers_extra = { "dartls", "spyglassmc_language_server" },
    },
    config = function(_, opts)
      require "david.plugins.lsp.lsp_attach"
      local lspconfig = require "lspconfig"
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local server_configs = require "david.plugins.lsp.server_configs"
      local defaults = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
      }

      local function setup(server)
        if type(opts.setup[server]) == "function" then
          opts.setup[server]()
        elseif opts.setup[server] ~= false then
          local config = vim.tbl_deep_extend("force", defaults, server_configs[server] or {})
          lspconfig[server].setup(config)
        end
      end

      for _, name in ipairs(opts.servers_extra) do
        setup(name)
      end

      local servers = require("mason-lspconfig").get_installed_servers()
      for _, name in ipairs(servers) do
        setup(name)
      end
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        config = true,
        opts = {
          ensure_installed = {
            "bashls",
            "clangd",
            "clojure_lsp",
            "cmake",
            "cssls",
            "fsautocomplete",
            "gopls",
            "html",
            "jdtls",
            "jsonls",
            "kotlin_language_server",
            "lua_ls",
            "omnisharp",
            "powershell_es",
            "prismals",
            "pyright",
            "rust_analyzer",
            "svelte",
            "tailwindcss",
            "texlab",
            "tsserver",
            "yamlls",
          },
        },
        dependencies = {
          "williamboman/mason.nvim",
        },
      },
      { "Hoffs/omnisharp-extended-lsp.nvim" },
      { "b0o/schemastore.nvim" },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = true,
    dependencies = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
          ensure_installed = {
            "eslint_d",
            "prettier",
            "black",
            "stylua",
            "selene",
            "golangci-lint",
            "clj-kondo",
            "commitlint",
            "pylint",
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    module = false,
  },
  {
    "CrystalAlpha358/vim-mcfunction",
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>vfm",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { { "prettier", "prettierd" } },
        typescript = { { "prettier", "prettierd" } },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      events = { "BufWritePost", "BufReadPost" },
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        go = { "golangcilint" },
        lua = { "selene" },
        python = { "pylint" },
        clojure = { "clj-kondo" },
        gitcommit = { "commitlint" },
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd(opts.events, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
