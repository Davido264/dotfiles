local set = vim.opt
local gset = vim.g

-- leader
gset.mapleader = " "
gset.maplocalleader = ","

-- file format
set.fileformat = "unix"

-- misc
set.mouse = "a"
set.inccommand = "split"
set.number = true
set.relativenumber = true
set.signcolumn = "yes"
set.viminfo = nil
set.colorcolumn = "120"
set.scrolloff = 8
set.wrap = false
--set.isfname:append "@-@"
set.hlsearch = false
set.ignorecase = true
set.splitright = true
gset.editorconfig = true

-- default tab behaviour
set.expandtab = true
set.smartindent = true
set.shiftwidth = 4
set.tabstop = 4

set.termguicolors = true

-- statusline
set.laststatus = 3
set.ruler = true
set.showcmd = false
set.list = true
set.cmdheight = 1
-- maybe set this https://github.com/neovim/neovim/issues/22478 gets implemented
-- set.laststatus = 3
-- set.cmdheight = 0
-- vim.api.nvim_create_autocmd("CmdlineEnter", {
--   pattern = "*",
--   callback = function()
--     vim.cmd "setlocal cmdheight=1"
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--   pattern = "*",
--   callback = function()
--     vim.cmd "call timer_start(1, { tid -> execute('setlocal cmdheight=0')})"
--   end,
-- })

-- set.listchars:append("stl:c' '")

-- latex
gset.tex_flavor = "latex"

-- Clipboard
set.clipboard:prepend { "unnamed", "unnamedplus" }

local is_wsl = function()
  local output = vim.fn.systemlist "uname -r"
  return string.find(output[1] or "", "WSL") or string.find(output[1] or "", "WSL2")
end

if is_wsl() then
  local copy = {}
  copy["+"] = "clip.exe"
  copy["*"] = "clip.exe"

  local paste = {}
  paste["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
  paste["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'

  gset.clipboard = {
    name = "WslClipboard",
    copy = copy,
    paste = paste,
    cache_enabled = 0,
  }
end

-- Terminal
if vim.fn.has "win32" == 1 then
  set.shell = "powershell"
  set.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  set.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  set.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  set.shellquote = ""
  set.shellxquote = ""
end

-- for extra config via .exrc
set.exrc = true

-- undodir
set.swapfile = false
set.backup = false
set.undofile = true
if vim.fn.has "win32" == 1 then
  set.undodir = os.getenv "userprofile" .. "/Appdata/Local/nvim-data/undo"
else
  set.undodir = os.getenv "HOME" .. "/.local/share/nvim/undodir"
end

-- native file browser
gset.netrw_browse_split = 0
gset.netrw_banner = 0
gset.netrw_winsize = 25

-- neovide
gset.neovide_cursor_vfx_mode = "wireframe"
gset.neovide_transparency = 1
set.guifont = "JetbrainsMono Nerd Font:h13"

-- folds
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
set.foldenable = false

-- disable providers
gset.loaded_node_provider = 0
gset.loaded_perl_provider = 0
gset.loaded_python3_provider = 0
gset.loaded_ruby_provider = 0
