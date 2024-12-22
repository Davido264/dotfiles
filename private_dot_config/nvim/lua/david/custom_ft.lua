-- xaml to xml
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = { "*.xaml" },
  callback = function()
    vim.opt_local.filetype = "xml"
  end,
})

-- tf to terraform
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = { "*.tf" },
  callback = function()
    vim.opt_local.filetype = "terraform"
  end,
})

-- termux-language-server fts
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "build.sh",
    "*.subpackage.sh",
  },
  callback = function()
    vim.opt_local.filetype = "sh.termux"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "PKGBUILD",
    "*.install",
    "makepkg.conf",
  },
  callback = function()
    vim.opt_local.filetype = "sh.PKGBUILD"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "*.ebuild",
    "*.eclass",
    "color.map",
    "make.conf",
  },
  callback = function()
    vim.opt_local.filetype = "sh.ebuild"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "*.gitlab-ci*.{yml,yaml}"
  },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

-- ansible fts
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "*/{tasks,roles,handlers,playbooks,group_vars,host_vars}/*.{yaml,yml}"
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = {
    "{playbook,site,main,local,requirements}.{yaml,yml}"
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" }, {
  pattern = "*.{jinja2,j2}",
  callback = function ()
    local path = vim.fn.expand("%:p")
    local splitted = vim.split(path,".")
    if #splitted <= 2 then
      return
    end

    vim.bo.filetype = splitted[#splitted - 1] .. ".jinja2"
  end
})
