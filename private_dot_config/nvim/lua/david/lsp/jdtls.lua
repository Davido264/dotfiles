local M = {}

function M.setup()
  require("lazy").load {
    plugins = {
      "nvim-jdtls",
    },
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Setup jdtls",
    pattern = "java",
    callback = function()
      local jdtlspath = require("mason-registry").get_package("jdtls"):get_install_path()
      local dappath = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
      local path_to_lsp_server = ""

      if vim.fn.has "win32" == 1 then
        path_to_lsp_server = jdtlspath .. "/config_win"
      elseif vim.fn.has "linux" == 1 then
        path_to_lsp_server = jdtlspath .. "/config_linux"
      else
        path_to_lsp_server = jdtlspath .. "/config_mac"
      end

      local path_to_plugins = jdtlspath .. "/plugins/"
      local path_to_jar = vim.fn.expand(jdtlspath .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      local lombok_path = path_to_plugins .. "lombok.jar"
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local wd = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          -- "-javaagent:" .. lombok_path,
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          path_to_jar,
          "-configuration",
          path_to_lsp_server,
          "-data",
          wd,
        },

        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),

        root_dir = require("jdtls.setup").find_root {
          ".git",
          "mvnw",
          "gradlew",
          "settings.gradle",
          "settings.gradle.kts",
          "build.gradle",
          "build.gradle.kts",
          "build.xml",
          "pom.xml",
        } or vim.fn.getcwd(),

        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath "config" .. "/styles/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
            },
            inlayHints = {
              parameterNames = {
                enabled = "all",
                exclusions = { "this" },
              },
            },
          },
        },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
          importOrder = {
            "java",
            "javax",
            "com",
            "org",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
        flags = {
          allow_incremental_sync = true,
        },

        init_options = {
          bundles = {
            vim.fn.glob(dappath .. "extension/server/com.microsoft.java.debug.plugin-*.jar", true),
          },
        },
      }
      require("jdtls").start_or_attach(config)
      require "david.dap" "jdtls"
    end,
  })
end

return M
