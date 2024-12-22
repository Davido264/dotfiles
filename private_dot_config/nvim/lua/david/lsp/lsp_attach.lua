vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = (vim.lsp.get_client_by_id(ev.data.client_id))
    if client == nil then
      return
    end

    -- set priorities for Nix highlights
    if not vim.bo.ft == "nix" then
      vim.highlight.priorities.semantic_tokens = 95
    end

    -- set indent
    local tab_configs = require("david.lsp.tab")[client.name] or { expand = true, size = 4 }

    if tab_configs then
      vim.bo[ev.buf].expandtab = tab_configs.expand
      vim.bo[ev.buf].shiftwidth = tab_configs.size
      vim.bo[ev.buf].tabstop = tab_configs.size
    end

    local map = require("david.keymaps").bmap
    local opts = { buffer = ev.buf }

    map("n", "K", vim.lsp.buf.hover, opts)

    map("n", "gd", require("telescope.builtin").lsp_definitions, opts)

    map("n", "gs", vim.lsp.buf.signature_help, opts)

    map("n", "gr", require("telescope.builtin").lsp_references, opts)

    map("n", "gR", require("telescope.builtin").lsp_incoming_calls, opts)

    map("n", "gD", vim.lsp.buf.declaration, opts)

    map("n", "gi", require("telescope.builtin").lsp_implementations, opts)

    map("n", "gt", require("telescope.builtin").lsp_type_definitions, opts)

    map("n", "<leader>vws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

    map("n", "<leader>vds", require("telescope.builtin").lsp_document_symbols, opts)

    map("n", "<leader>vrn", vim.lsp.buf.rename, opts)

    map("n", "<leader>vcd", require("telescope.builtin").diagnostics, opts)

    map("n", "<leader>vca", vim.lsp.buf.code_action, opts)

    map("n", "<leader>vih", function()
      if vim.lsp.inlay_hint.is_enabled {} then
        vim.lsp.inlay_hint.enable(false)
        require("fidget").notify "inlay hints disabled"
      else
        vim.lsp.inlay_hint.enable(true)
        require("fidget").notify "inlay hints enabled"
      end
    end, opts)

    map("n", "gl", vim.diagnostic.open_float, opts)

    map("n", "[d", vim.diagnostic.goto_prev, opts)

    map("n", "]d", vim.diagnostic.goto_next, opts)

    require("fidget").notify("lsp: [ " .. client.name .. " ]")
    require "david.dap"(client.name, ev.buf)
  end,
})
