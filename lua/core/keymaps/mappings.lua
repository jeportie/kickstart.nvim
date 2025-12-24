local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })

map('n', '<leader>wk', function()
  vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'whichkey query lookup' })

-- map('n', '<leader>fm', function()
--   require('plugins.').format { lsp_fallback = true }
-- end, { desc = 'general format file' })

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- nvchad
map('n', '<leader>nth', function()
  require('nvchad.themes').open()
end, { desc = 'telescope nvchad themes' })

-- Lspsaga

----- File Navigation -----
opts.desc = 'Open Mini Files'
map('n', '<leader>e', function()
  require('mini.files').open()
  vim.wo.cursorline = false
  vim.wo.cursorcolumn = false
end, opts)
