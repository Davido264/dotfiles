local function notifyfn(executable)
  require("fidget").notify(executable .. " required and not found.")
end

return function(client, buff)
  local package = "david.dap." .. client

  local ok, mod = pcall(require, package)

  if not ok then
    return
  end

  require("fidget").notify("Configuring dap for " .. client)

  if not mod.check_required(notifyfn) then
    require("fidget").notify "No DAP set"
    return
  end

  require("lazy").load {
    plugins = {
      "nvim-dap",
    },
  }
  mod.setup()

  local dap = require "dap"
  local dapui = require "dapui"
  local map = require("david.keymaps").bmap
  local opts = { buffer = buff }

  -- Here I tried to copy the Intellij debug shortcuts
  -- https://www.oreilly.com/library/view/intellij-idea-essentials/9781784396930/ch08s08.html
  -- Ctrl + F8 == F32
  map("n", "<F32>", dap.toggle_breakpoint, opts)
  -- F7
  map("n", "<F7>", dap.step_into, opts)
  -- F8
  map("n", "<F8>", dap.step_over, opts)
  -- F9
  map("n", "<F9>", dap.continue, opts)
  -- Alt + F9 == F57
  map("n", "<F57>", dap.run_to_cursor, opts)
  -- Alt + F8 == F56
  map("n", "<F56>", function()
    dapui.eval(nil, { enter = true })
  end, opts)
  -- Shift + F1 == F13
  map("n", "<F13>", dapui.toggle, opts)

  -- Some TJ bindings
  -- map("n", "<F4>", dap.step_out, opts)
  -- map("n", "<F5>", dap.step_back, opts)
  -- map("n", "<F13>", dap.restart, opts)
end
