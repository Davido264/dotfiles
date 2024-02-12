return {
  ["gopls"] = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
  ["jsonls"] = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  ["lua_ls"] = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        format = {
          enable = true,
          -- Put format options here
          -- NOTE: the value should be STRING!!
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
      },
    },
  },
  ["omnisharp"] = {
    handlers = {
      ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
    organize_imports_on_format = true,
  },
  ["prettier"] = {
    autostart = false,
  },
  ["powershell_es"] = {
    bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
  },
  ["pyright"] = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ["tailwindcss"] = {
    autostart = false,
  },
  ["tsserver"] = {
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
  },
  ["yamlls"] = {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}
