return {
  "kylechui/nvim-surround",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    require("nvim-surround").setup {}
  end,
}
