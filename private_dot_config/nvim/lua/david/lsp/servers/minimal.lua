local M = {}

M.servers = {
  -- Ansible
  "ansible-language-server",

  -- Bash/sh
  "bash-language-server",

  -- C/C++
  "clangd",
  "cmake-language-server",

  -- Lua
  "lua-language-server",

  -- Python
  "pyright",

  -- LaTeX
  "texlab",

  -- Not managed by lspconfig
  "termux_language_server"
}


M.tools = {
  -- Ansible
  "ansible-lint",

  -- Bash/sh
  "shellcheck",
  "shfmt",

  -- Lua
  "selene",
  "stylua",
}


return M
