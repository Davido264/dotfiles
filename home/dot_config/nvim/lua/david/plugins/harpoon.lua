return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Mark file",
      silent = true,
    },
    {
      "<C-e>",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Show marks",
      silent = true,
    },
    {
      "<C-j>",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Navigate to mark",
      silent = true,
    },
    {
      "<C-k>",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Navigate to mark",
      silent = true,
    },
    {
      "<C-l>",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Navigate to mark",
      silent = true,
    },
    {
      "<C-h>",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Navigate to mark",
      silent = true,
    },
  },
  config = true,
}
