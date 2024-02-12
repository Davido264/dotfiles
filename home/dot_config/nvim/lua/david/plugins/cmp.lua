return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require "cmp"
    local defaults = require("cmp.config.default")()
    return {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },
      },

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      },{
          { name = "buffer" },
      }),

      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },

      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local function trim(text)
            local max = 50
            if text and text:len() > max then
              text = text:sub(1, max) .. "..."
            end
            return text
          end

          vim_item.abbr = trim(vim_item.abbr)
          vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
          return vim_item
        end,
      },
      sorting = defaults.sorting,
    }
  end,

  config = function (_,opts)
    local cmp = require("cmp")
    cmp.setup(opts)
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources {
        { name = "conventionalcommits" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end,

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    {
      "davidsierradz/cmp-conventionalcommits",
      ft = "gitcommit",
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        {
          "saadparwaiz1/cmp_luasnip",
        },
      },
      opts = {
        history = true,
        delete_check_events = "TextChanged",
      },
      config = function (_,opts)
        require("luasnip").setup(opts)
        local extras = vim.fn.stdpath "config" .. "/snippets"
        -- require("luasnip.loaders.from_vscode").lazy_load { paths = extras }
      end,
    },
    {
      "echasnovski/mini.pairs",
      event = "VeryLazy",
      opts = {},
      config = true,
    },
  },
}
