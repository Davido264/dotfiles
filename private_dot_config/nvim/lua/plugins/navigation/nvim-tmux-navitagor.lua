if vim.fn.has("win32") == 1 then
  return {}
end

return {
  "alexghergh/nvim-tmux-navigation",
  lazy = false,
  opts = {
    disabled_when_zoomed = true,
    keybindings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },
  },
  config = true,
}
