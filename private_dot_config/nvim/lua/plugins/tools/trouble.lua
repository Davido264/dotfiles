return {
  "folke/trouble.nvim",
  event = "LspAttach",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle "workspace_diagnostics"
      end,
      desc = "Workspace Diagnostics",
      silent = true,
    },
  },
  opts = {},
  config = true,
}
