local ok, res = pcall(require, "plugins.ui.astrotheme")
if not ok then
    res = {}
end

return {
  require "plugins.ui.fidget",
  require "plugins.ui.gitsigns",
  require "plugins.ui.nvim_web_devicons",
  require "plugins.ui.lualine",
  res
}
