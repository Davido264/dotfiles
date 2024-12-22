local path = os.getenv "XDG_DATA_HOME"

if not path then
  if vim.fn.has "win32" == 1 then
    path = os.getenv "APPDATA"
  else
    path = os.getenv "HOME" .. "/.local/share"
  end
end

vim.api.nvim_create_user_command("ReloadConfig", function()
  for name, _ in pairs(package.loaded) do
    if name:match "^david" then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end, { nargs = 0, desc = "Reload Configs" })

vim.api.nvim_create_user_command("Sh", function()
  local s = vim.api.nvim_buf_get_mark(0, "<")
  local e = vim.api.nvim_buf_get_mark(0, ">")

  -- Get the selected text
  local selected_text = vim.api.nvim_buf_get_lines(0, s[1] - 1, e[1], false)
  local cmd = selected_text[1]

  local out = vim.fn.system(cmd)
  print(out)
end, { range = true, nargs = 0, desc = "Execute" })

-- ":'<,'>w !powershell -NoLogo -NoProfile -ExecutionPolicy RemoteSigned<CR>"

vim.api.nvim_create_user_command("Info", function()
  local git = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
  local git_path = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local git_name = vim.fn.system("basename " .. git_path):gsub("\n", "")

  if git and git ~= "" then
    git = " on " .. git_name .. "/" .. git
  end

  local file = vim.fn.expand "%"
  local ft = " of type " .. vim.bo.filetype

  vim.notify(file .. git .. ft)
end, { nargs = 0, desc = "Get current file information" })
