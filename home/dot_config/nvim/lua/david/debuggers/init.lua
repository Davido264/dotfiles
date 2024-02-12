return function(client)
  local name = string.gsub(client.name, "%.", "")
  local package = "david.lsp.debuggers." .. name
  local ok, _ = pcall(require, package)
  if ok then
    require("nvim-dap-virtual-text").setup()
    local dapui = require "dapui"
    dapui.setup {
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "watches",
          },
          size = 40,
          position = "left",
        },
      },
    }
    local dap = require "dap"
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end
  return ok
end
