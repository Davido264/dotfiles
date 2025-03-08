return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "Shatur/neovim-ayu"
  },
  opts = {
    component_separators = { left = "", right = ""},
    section_separators = { left = "", right = ""},
    options = {
      theme = "ayu",
    }
  },
  config = true
}
