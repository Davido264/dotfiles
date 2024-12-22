local M = {}

function M.check_required(notifyfn)
  local node2_installed = require("mason-registry").get_package("node-debug2-adapter"):is_installed()
  local ff_installed = require("mason-registry").get_package("firefox-debug-adapter"):is_installed()
  if not (node2_installed and ff_installed) then
    notifyfn "node-debug2-adapter and/or firefox-debug-adapter"
  end
  return node2_installed and ff_installed
end

function M.setup()
  local dap = require "dap"

  dap.adapters.node2 = {
    type = "executable",
    command = "node-debug2-adapter",
  }

  dap.adapters.firefox = {
    type = "executable",
    command = "firefox-debug-adapter",
  }

  for _, language in pairs { "javascript", "typescript" } do
    require("dap").configurations[language] = {
      {
        name = "Launch Node against current file",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Launch Node against pick process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
        console = "integratedTerminal",
      },
      {
        name = "Launch Firefox against localhost",
        request = "launch",
        type = "firefox",
        reAttach = true,
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        console = "integratedTerminal",
      },
    }
  end

  for _, language in pairs { "javascriptreact", "typescriptreact" } do
    require("dap").configurations[language] = {
      {
        name = "Launch Firefox against localhost",
        request = "launch",
        type = "firefox",
        reAttach = true,
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        console = "integratedTerminal",
      },
    }
  end
end

return M
