return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    git = {
      -- Return true to automatically git add/mv/rm files
      add = function(_)
        return true
      end,
      mv = function(_)
        return false
      end,
      rm = function(_)
        return false
      end,
    },
  },
  keys = {
    {
      "<leader>FF",
      "<CMD>Oil --float<CR>",
      desc = "Open file browser",
      silent = true,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
