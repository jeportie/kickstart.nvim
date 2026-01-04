return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      '<leader>fs',
      function()
        require('telescope.builtin').lsp_document_symbols()
      end,
      desc = 'Telescope Document symbols',
    },
    {
      '<leader>fS',
      function()
        require('telescope.builtin').lsp_dynamic_workspace_symbols()
      end,
      desc = 'Workspace symbols',
    },

  }
}
