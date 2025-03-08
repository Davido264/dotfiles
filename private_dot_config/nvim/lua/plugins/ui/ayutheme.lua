return {
  "Shatur/neovim-ayu",
  lazy = false,
  init = function ()
    vim.cmd [[ colorscheme ayu-dark ]]
  end,
  config = function()
    local colors = require("ayu.colors")
    colors.generate(false)

    require("ayu").setup({
    mirage = false,
    terminal = true,
    overrides = {
      LineNr = { bg = colors.line },
      CursorColumn = { bg = colors.line },
      Normal = { bg = "None" },
      NormalFloat = { bg = "none" },
      SignColumn = { bg = "None" },
      Folded = { bg = "None" },
      FoldColumn = { bg = "None" },
      CursorLine = { bg = "None" },
      VertSplit = { bg = "None" },
    },
  })
  end
}
