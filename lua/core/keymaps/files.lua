local map = vim.keymap.set

-- NvimTree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>ee', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- MiniFiles
map('n', '<leader>ef', function()
  require('mini.files').open()
  vim.wo.cursorline = false
  vim.wo.cursorcolumn = false
end, { desc = 'Open MiniFiles' })
