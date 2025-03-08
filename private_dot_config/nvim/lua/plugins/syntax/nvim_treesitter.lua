return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  cmd = { "TSInstall", "TSInstallSync", "TSInstallInfo", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      -- Bash/sh
      "bash",

      -- C/C++
      "c",
      "cpp",
      "llvm",

      -- Clojure/babashka
      "clojure",

      -- Go
      "go",
      "gotmpl",
      "gowork",
      "gomod",

      -- Java
      "java",
      "groovy",

      -- Kotlin
      "kotlin",
      -- Kdl (for zellij configuration)
      "kdl",

      -- Lua
      "lua",
      "luadoc",
      "luap",
      "luau",
      "fennel",

      -- Dotnet
      "c_sharp",
      "fsharp",

      -- Python
      "python",
      "requirements",
      "pymanifest",

      -- LaTeX
      "bibtex",
      "latex",

      -- Javascript/Typescript
      "javascript",
      "jsdoc",
      "typescript",
      "typespec",
      "typoscript",

      -- Web Frameworks
      "svelte",
      "tsx",
      "htmldjango",
      "angular",
      "astro",
      "embedded_template",
      "vue",

      -- HTML/CSS/JSON/YAML/TOML
      "html",
      "scss",
      "css",
      "yaml",
      "json",
      "json5",
      "jsonc",
      "toml",

      -- Rust
      "rust",

      -- Dart
      "dart",

      -- Markdown
      "markdown",
      "markdown_inline",

      -- SQL
      "sql",

      -- Git
      "diff",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",

      -- Scheme
      "scheme",

      -- Other
      "bass",
      "beancount",
      "cmake",
      "comment",
      "cooklang",
      "csv",
      "dockerfile",
      "http",
      "hyprlang",
      "ini",
      "make",
      "query",
      "regex",
      "templ",
      "tsv",
      "vim",
      "vimdoc",
      "xml",
      "editorconfig",
      "printf",
      "ssh_config",
    },
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
  },
  config = function(_, opts)
    vim.filetype.add {
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    }

    require("nvim-treesitter.configs").setup(opts)

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

    -- local mcfunction = vim.fn.stdpath "data" .. "/tree-sitter-mcfunction"
    -- parser_config.mcfunction = {
    --   install_info = {
    --     url = mcfunction,
    --     files = { "src/parser.c" },
    --   },
    --   filetype = "mcfunction",
    -- }
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
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    },
  },
}
