return {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  keys = {
    { "<leader>FF", "<CMD>NvimTreeToggle<CR>", desc = "Find file in filetree" },
  },
  opts = {
    filters = {
      custom = { ".git", "node_modules", ".vscode" },
      dotfiles = true,
    },
    git = {},
    view = {
      width = 30,
      adaptive_size = true,
      float = {
        enable = false,
      },
    },
  },
}
