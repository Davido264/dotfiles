local M = {}

function M.check_required(notifyfn)
  local installed = require("mason-registry").get_package("netcoredbg"):is_installed()
  if not installed then
    notifyfn "netcoredbg"
  end
  return installed
end

function M.setup()
  local dap = require "dap"

  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
      end,
    },
  }
end

return M
