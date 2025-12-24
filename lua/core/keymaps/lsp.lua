local map = vim.keymap.set

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- Format
map('n', '<leader>fm', function()
  require('plugins.').format { lsp_fallback = true }
end, { desc = 'general format file' })
