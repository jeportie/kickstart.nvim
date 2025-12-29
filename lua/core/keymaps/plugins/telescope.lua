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
    'gd',
    function()
      require('telescope.builtin').lsp_definitions()
    end,
    desc = 'LSP definitions',
  },
  {
    'gi',
    function()
      require('telescope.builtin').lsp_implementations()
    end,
    desc = 'LSP implementations',
  },
  {
    'gt',
    function()
      require('telescope.builtin').lsp_type_definitions()
    end,
    desc = 'LSP type definitions',
  },
  {
    'gO',
    function()
      require('telescope.builtin').lsp_document_symbols()
    end,
    desc = 'Document symbols',
  },
  {
    'gW',
    function()
      require('telescope.builtin').lsp_dynamic_workspace_symbols()
    end,
    desc = 'Workspace symbols',
  },
}

return M
