return {
  "L3MON4D3/LuaSnip",
  opts = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
  },
  config = function(_, opts)
    local types = require "luasnip.util.types"
    opts.ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "Cursor" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "Cursor" } },
        },
      },
    }

    require("luasnip").setup(opts)
    local ls = require "luasnip"
    local snippets_path = vim.api.nvim_get_runtime_file("snippets/*.lua", true)
    for _, ft_path in ipairs(snippets_path) do
      loadfile(ft_path)()
    end

    vim.keymap.set({ "i", "s" }, "<A-j>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<A-k>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
  end,
}
