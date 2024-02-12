return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = {},
      },
      matchup = {
        enable = true,
      },
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "clojure",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "prisma",
        "python",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
      sync_install = false,
      autotag = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

      local fsharp = vim.fn.stdpath "data" .. "/tree-sitter-fsharp"
      parser_config.fsharp = {
        install_info = {
          url = fsharp,
          files = { "src/scanner.cc", "src/parser.c" },
        },
        filetype = "fsharp",
      }

      local mcfunction = vim.fn.stdpath "data" .. "/tree-sitter-mcfunction"
      parser_config.mcfunction = {
        install_info = {
          url = mcfunction,
          files = { "src/parser.c" },
        },
        filetype = "mcfunction",
      }
    end,
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        config = true,
      },
      {
        "andymass/vim-matchup",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        config = function  ()
          vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end
      }
    }
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "gpanders/nvim-parinfer",
    event = "VeryLazy",
    ft = {"clojure"}
  },
}
