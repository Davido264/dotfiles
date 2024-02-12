local path = os.getenv "XDG_DATA_HOME"

if not path then
  if vim.fn.has "win32" == 1 then
    path = os.getenv "APPDATA"
  else
    path = os.getenv "HOME" + "/.local/share"
  end
end

vim.api.nvim_create_user_command("OpenUrlsFile", function()
  vim.cmd("botright vnew " .. path .. "/workspaces_urls")
end, { nargs = 0, desc = "Open Urls File" })

vim.api.nvim_create_user_command("OpenTaskFile", function()
  vim.cmd("botright vnew " .. path .. "/workspaces_todos")
end, { nargs = 0, desc = "Open Tasks File" })

vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match('^david') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end, { nargs = 0, desc = "Reload Configs" })

vim.api.nvim_create_user_command("Sh", function ()
  local s = vim.api.nvim_buf_get_mark(0, "<")
  local e = vim.api.nvim_buf_get_mark(0, ">")

  -- Get the selected text
  local selected_text = vim.api.nvim_buf_get_lines(0, s[1] - 1, e[1], false)
  local cmd = selected_text[1]

  local out = vim.fn.system(cmd)
  print(out)
end, { range = true,nargs = 0, desc = "Execute" })

-- ":'<,'>w !powershell -NoLogo -NoProfile -ExecutionPolicy RemoteSigned<CR>"
