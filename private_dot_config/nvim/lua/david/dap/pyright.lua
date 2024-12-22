local M = {}

function M.check_required(notifyfn)
  local installed = require("mason-registry").get_package("debugpy"):is_installed()
  if not installed then
    notifyfn "debugpy"
  end
  return installed
end

function M.setup()
  local dap = require "dap"

  dap.adapters.python = {
    type = "executable",
    command = "debugpy",
  }

  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Launch file",

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = "${file}", -- This configuration will launch the current file if used.
    },
  }
end

return M
