return function (server_name)
  local ok, settings = pcall(require,"david.lsp.custom_server_configs." .. server_name)

  if not ok then
    return {}
  end

  return settings
end
