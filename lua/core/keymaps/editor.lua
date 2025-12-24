local map = vim.keymap.set

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Remap ";" in normal mode to enter command mode
map('n', ';', ':', { desc = 'Enter command mode' })
-- Map "jk" in insert mode to exit to normal mode
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })
-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- general
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<Left>', '<C-w>h', { desc = 'Move focus to the left window' })
map('n', '<Right>', '<C-w>l', { desc = 'Move focus to the right window' })
map('n', '<Down>', '<C-w>j', { desc = 'Move focus to the lower window' })
map('n', '<Up>', '<C-w>k', { desc = 'Move focus to the upper window' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'general copy whole file' })

-- UI toggles
map('n', '<leader>ur', '<cmd>set rnu!<CR>', { desc = 'Toggle relative numbers' })

vim.keymap.set('n', '<leader>uc', function()
  if vim.wo.colorcolumn:find '80' then
    vim.cmd 'set colorcolumn-=80'
  else
    vim.cmd 'set colorcolumn=80'
  end
end, { desc = 'Toggle colorcolumn (80)' })

-- Comment
-- map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })

-- help / cheats
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', { desc = 'NVChad Cheatsheet' })
