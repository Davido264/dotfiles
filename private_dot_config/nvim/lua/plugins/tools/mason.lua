local ok, mode = pcall(require, "david.lsp.servers.current")

if not ok then
  mode = "normal"
end

local function filter_available_servers()
  local mason_servers = require("mason-lspconfig").get_available_servers()
  local final = {}

  for _, server in ipairs(require("david.lsp.servers." .. mode).servers) do
    if vim.tbl_contains(mason_servers, server) then
      table.insert(final, server)
    end
  end

  return final
end

return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    build = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
          local treesitter_finished = false
          -- Note to myself.
          -- This registers a callback on the event MasonToolsUpdateCompleted. Which raises when all mason
          -- tools defined in `ensure_installed` are installed.
          -- The callback checks for the message "[nvim-treesitter] [%i/%i]..." which is a message that treesitter
          -- logs during the process of installing a new parser, when the process finishes, the log message starts
          -- with "[nvim-treesitter] [%i/%i]..." and ends with "installed", So, if the last parser was installed
          -- correctly, the regex will capture both "%i" (asuming "%i" is an integer) and compare them. If they are
          -- the same, it quits as this means all parsers of treesitter are installed.
          -- HOWEVER
          -- If the las parser fails, it will be stuck on an infinite loop. The solution to this is:
          --    1. More regexes
          --    2. Capture the last word to take in count "installed" and whatever term nvim-treesiteer uses to tell
          --       things went wrong
          --    3. Not check at all, leading to race conditions, because this event will quit neovim
          --    4. Contribute to nvim-treesitter to include this event and have a less hacky solution using vim variables
          --
          -- TODO: When I have the time, go for the option 4, https://github.com/nvim-treesitter/nvim-treesitter/issues/2900 had
          -- the same problem almost 2 years ago
          --
          vim.api.nvim_create_autocmd("User", {
            pattern = "MasonToolsUpdateCompleted",
            callback = function()
              vim.schedule(function()
                while true do
                  local messages = vim.split(vim.fn.execute("messages", "silent"), "\n")
                  for _, val in ipairs(messages) do
                    local g1, g2 = string.match(val, "%[nvim%-treesitter%]%s+%[(%d+)%/(%d+).*%].*installed")
                    if g1 ~= nil then
                      if g1 == g2 then
                        treesitter_finished = true
                        vim.uv.sleep(10)
                      end
                    end
                  end

                  if treesitter_finished then
                    break
                  end

                  -- Sleep for 2 min
                  vim.uv.sleep(60000)
                end

                vim.cmd [[:qa]]
              end)
            end,
          })
        end,
      })
      require("mason-tool-installer").check_install(false)
    end,
    config = true,
    setup = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = true,
        ["mason-nvim-dap"] = true,
      },
      run_on_start = false,
    },
    config = function(_, opts)
      opts.ensure_installed =
        vim.tbl_deep_extend("force", filter_available_servers(), require("david.lsp.servers." .. mode).tools)
      require("mason-tool-installer").setup(opts)
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        config = true,
        dependencies = {
          "williamboman/mason.nvim"
        }
      },
    },
  },
}
