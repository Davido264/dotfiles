return {
  "mfussenegger/nvim-dap",
  module = false,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "williamboman/mason.nvim",
    "nvim-neotest/nvim-nio",
  },
  opts = {
    -- layouts = {
    --   {
    --     elements = {
    --       -- Elements can be strings or table with id and size keys.
    --       { id = "scopes", size = 0.25 },
    --       "breakpoints",
    --       "watches",
    --     },
    --     size = 40,
    --     position = "left",
    --   },
    -- },
  },
  config = function(_, opts)
    local dap = require "dap"
    local dapui = require "dapui"

    require("dapui").setup(opts)
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
