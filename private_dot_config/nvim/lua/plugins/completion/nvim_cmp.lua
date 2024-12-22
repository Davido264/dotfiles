return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  opts = function()
    local lspkind = require "lspkind"

    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require "cmp"
    local defaults = require "cmp.config.default"()
    return {
      completion = {
        completeopt = "menu,menuone,noselect",
      },

      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },

      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping.confirm { select = true },
      },

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),

      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },

      formatting = {
        format = lspkind.cmp_format {
          mode = "symbol",
          maxwidth = function()
            return math.floor(0.30 * vim.o.columns)
          end,
          ellipsis_char = "...",
          show_labelDetails = true,
        },
      },

      sorting = defaults.sorting,

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    }
  end,

  config = function(_, opts)
    local cmp = require "cmp"
    cmp.setup(opts)
    -- cmp.setup.cmdline(":", {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = "path" },
    --   }, {
    --     {
    --       name = "cmdline",
    --       option = {
    --         ignore_cmds = { "Man", "!" },
    --       },
    --     },
    --   }),
    -- })
  end,

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    -- "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "onsails/lspkind.nvim",
  },
}
