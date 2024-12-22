return {
  "ThePrimeagen/git-worktree.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  init = function ()
    require("telescope").load_extension("git_worktree")
  end,
  keys = {
    {
      "<leader>g",
      function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end,
      desc = "Switch to Buffer",
      silent = true,
    },
  }
}
