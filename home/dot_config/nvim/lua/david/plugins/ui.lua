local colorschemes = {
  solarized = {
    "shaunsingh/solarized.nvim",
    lazy = false,
    init = function()
      vim.cmd.colorscheme "solarized"
    end,
    config = function()
      vim.g.solarized_contrast = false
      vim.g.solarized_borders = false
      vim.g.solarized_disable_background = true
    end,
  },

  gruvbox = {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    init = function()
      vim.cmd.colorscheme "gruvbox"
    end,
    opts = {
      contrast = "hard", -- can be "hard", "soft" or empty string
      transparent_mode = true,
    },
    config = function(_, opts)
      vim.g.gruvbox_contrast_dark = "hard"
      vim.g.gruvbox_invert_selection = "0"
      require("gruvbox").setup(opts)
    end,
  },

  catppuccin = {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    init = function()
      vim.cmd.colorscheme "catppuccin"
    end,
    config = function()
      vim.g.catppuccin_flavour = "mocha"
      require("catppuccin").setup()
    end,
  },
}

return {
  colorschemes.gruvbox,
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {}
  }
}
