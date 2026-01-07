return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}

    -- IMPORTANT: override LSP-attached keymaps
    opts.servers["*"].keys = {
      { "K",          false },
      { "<leader>ca", false },

      { 'K',          '<Cmd>Lspsaga hover_doc<CR>',                       mode = { 'n', 'i' },                 desc = 'Hover Docs' },
      { '<CR>',       '<Cmd>Lspsaga show_cursor_diagnostics<CR>',         desc = 'Show cursor diagnostics' },
      { '<leader>ca', '<Cmd>Lspsaga code_action<CR>',                     desc = 'Code action' },
      { "<leader>cA", LazyVim.lsp.action.source,                          desc = "Source Action",              has = "codeAction" },
      { '<leader>cd', '<Cmd>Lspsaga show_line_diagnostics<CR>',           desc = 'Show line diagnostics' },
      { '<leader>cb', '<Cmd>Lspsaga show_buf_diagnostics<CR>',            desc = 'Show buffer diagnostics' },
      { '<leader>cw', '<Cmd>Lspsaga show_workspace_diagnostics<CR>',      desc = 'Show workspace diagnostics' },
      { '<leader>cp', '<Cmd>Lspsaga peek_definition<CR>',                 desc = 'Peek Definition' },
      { "<leader>cl", function() Snacks.picker.lsp_config() end,          desc = "Lsp Info" },
      { "<leader>cc", vim.lsp.codelens.run,                               desc = "Run Codelens",               mode = { "n", "x" },     has = "codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh,                           desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
      { "<leader>cr", vim.lsp.buf.rename,                                 desc = "Rename Element",             has = "rename" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,         desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
      { '<leader>cs', '<Cmd>Lspsaga outline<CR>',                         desc = 'Symbols Outline' },
      { "gd",         vim.lsp.buf.definition,                             desc = "Goto Definition",            has = "definition" },
      { "gr",         vim.lsp.buf.references,                             desc = "References",                 nowait = true },
      { "gI",         vim.lsp.buf.implementation,                         desc = "Goto Implementation" },
      { "gy",         vim.lsp.buf.type_definition,                        desc = "Goto T[y]pe Definition" },
      { "gD",         vim.lsp.buf.declaration,                            desc = "Goto Declaration" },
      { "gK",         function() return vim.lsp.buf.signature_help() end, desc = "Signature Help",             has = "signatureHelp" },
      { "<c-k>",      function() return vim.lsp.buf.signature_help() end, mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        has = "documentHighlight",
        desc = "Next Reference",
        enabled = function() return Snacks.words.is_enabled() end
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        has = "documentHighlight",
        desc = "Prev Reference",
        enabled = function() return Snacks.words.is_enabled() end
      },
      {
        "<a-n>",
        function() Snacks.words.jump(vim.v.count1, true) end,
        has = "documentHighlight",
        desc = "Next Reference",
        enabled = function() return Snacks.words.is_enabled() end
      },
      {
        "<a-p>",
        function() Snacks.words.jump(-vim.v.count1, true) end,
        has = "documentHighlight",
        desc = "Prev Reference",
        enabled = function() return Snacks.words.is_enabled() end
      },
    }

    return opts
  end,
}
