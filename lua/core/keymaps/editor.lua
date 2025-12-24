local map = vim.keymap.set
local global = vim.g

-- Leader keys
global.mapleader = ' '
global.maplocalleader = ','

-- General
map('n', ';', ':', { desc = 'Enter command mode' })

map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<Left>', '<C-w>h', { desc = 'Move focus to the left window' })
map('n', '<Right>', '<C-w>l', { desc = 'Move focus to the right window' })
map('n', '<Down>', '<C-w>j', { desc = 'Move focus to the lower window' })
map('n', '<Up>', '<C-w>k', { desc = 'Move focus to the upper window' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })

map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'Copy file' })

-- UI toggles
map('n', '<leader>ur', '<cmd>set rnu!<CR>', { desc = 'Toggle relative numbers' })

map('n', '<leader>uc', function()
  if vim.wo.colorcolumn:find '80' then
    vim.cmd 'set colorcolumn-=80'
  else
    vim.cmd 'set colorcolumn=80'
  end
end, { desc = 'Toggle colorcolumn (80)' })

-- Comments
map('n', '<leader>/', '<cmd>normal gcc<CR>', {
  desc = 'Toggle comment line',
})

map('v', '<leader>/', '<cmd>normal gc<CR>', {
  desc = 'Toggle comment selection',
})

-- NvChad
map('n', '<leader>nth', function()
  require('nvchad.themes').open()
end, { desc = 'telescope nvchad themes' })
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', { desc = 'NVChad Cheatsheet' })

-- WhichKey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })

map('n', '<leader>wk', function()
  vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'whichkey query lookup' })
