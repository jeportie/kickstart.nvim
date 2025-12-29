local M = {}

M.keys = {
  {
    'gr',
    function()
      require('telescope.builtin').lsp_references()
    end,
    desc = 'LSP references',
  },
  {
    '<leader>ld',
    function()
      require('telescope.builtin').lsp_definitions()
    end,
    desc = 'Telescope LSP definitions',
  },
  {
    '<leader>li',
    function()
      require('telescope.builtin').lsp_implementations()
    end,
    desc = 'Telescope LSP implementations',
  },
  {
    '<leader>lt',
    function()
      require('telescope.builtin').lsp_type_definitions()
    end,
    desc = 'Telescope LSP type definitions',
  },
  {
    '<leader>lo',
    function()
      require('telescope.builtin').lsp_document_symbols()
    end,
    desc = 'Telescope Document symbols',
  },
  {
    '<leader>lws',
    function()
      require('telescope.builtin').lsp_dynamic_workspace_symbols()
    end,
    desc = 'Workspace symbols',
  },
}

return M
