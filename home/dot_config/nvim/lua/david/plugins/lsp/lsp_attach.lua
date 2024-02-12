vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = (vim.lsp.get_client_by_id(ev.data.client_id))
    -- set indent
    local tab_size = require("david.plugins.lsp.tabsize")[client.name]

    if tab_size then
      vim.bo[ev.buf].expandtab = true
      vim.bo[ev.buf].shiftwidth = tab_size
      vim.bo[ev.buf].tabstop = tab_size
    end

    local map = require("david.keymaps").bmap
    local opts = { buffer = ev.buf }

    map("n", "K", function()
      vim.lsp.buf.hover()
    end, opts)

    map("n", "gd", function()
      require("telescope.builtin").lsp_definitions()
    end, opts)

    map("n", "gs", function()
      vim.lsp.buf.signature_help()
    end, opts)

    map("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end, opts)

    map("n", "gR", function()
      require("telescope.builtin").lsp_incoming_calls()
    end, opts)

    map("n", "gD", function()
      vim.lsp.buf.declaration()
    end, opts)

    map("n", "gi", function()
      require("telescope.builtin").lsp_implementations()
    end, opts)

    map("n", "gt", function()
      require("telescope.builtin").lsp_type_definitions()
    end, opts)

    map("n", "<leader>vws", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, opts)

    map("n", "<leader>vds", function()
      require("telescope.builtin").lsp_document_symbols()
    end, opts)

    map("n", "<leader>vrn", function()
      vim.lsp.buf.rename()
    end, opts)

    map("n", "<leade>vcd", function()
      require("telescope.builtin").diagnostics()
    end, opts)

    map("n", "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, opts)

    map("n", "gl", function()
      vim.diagnostic.open_float()
    end, opts)

    map("n", "[d", function()
      vim.diagnostic.goto_prev()
    end, opts)

    map("n", "]d", function()
      vim.diagnostic.goto_next()
    end, opts)

    require("fidget").notify("lsp: [ " .. client.name .. " ]")
  end,
})
