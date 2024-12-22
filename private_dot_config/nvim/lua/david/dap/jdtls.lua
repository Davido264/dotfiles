local M = {}

function M.check_required(notifyfn)
  local installed = require("mason-registry").get_package("java-debug-adapter"):is_installed()
  if not installed then
    notifyfn "java-debug-adapter"
  end
  return installed
end

function M.setup()
  require("jdtls").setup_dap({hotcodereplace = 'auto'})
end

return M
