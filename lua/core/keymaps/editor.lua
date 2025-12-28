local map = vim.keymap.set
local g = vim.g

-- Leader keys
g.mapleader = ' '
g.maplocalleader = ','

-- ============================================================================
-- General
-- ============================================================================

map('n', ';', ':', { desc = 'Enter command mode' })
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'Copy whole file' })

-- ============================================================================
-- Window navigation
-- ============================================================================

map('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus upper window' })

map('n', '<Left>', '<C-w>h', { desc = 'Focus left window' })
map('n', '<Right>', '<C-w>l', { desc = 'Focus right window' })
map('n', '<Down>', '<C-w>j', { desc = 'Focus lower window' })
map('n', '<Up>', '<C-w>k', { desc = 'Focus upper window' })

-- ============================================================================
-- Scrolling & centering
-- ============================================================================

map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })

map('n', '<C-e>', '<C-e>j', { desc = 'Scroll down with cursor follow' })
map('n', '<C-y>', '<C-y>k', { desc = 'Scroll up with cursor follow' })

map('n', 'n', 'nzzzv', { desc = 'Next search result centered' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result centered' })

-- ============================================================================
-- Search & replace
-- ============================================================================

map('n', '<leader>rs', '/\\v<><Left>', {
  desc = 'Search word boundary (\\v< >)',
})

map('n', '<leader>rw', function()
  vim.cmd [[
    let @/='\<'.expand('<cword>').'\>'
    %s/<C-r>//g
  ]]
end, { desc = 'Rename word under cursor' })

-- ============================================================================
-- Insert mode navigation
-- ============================================================================

map('i', '<C-h>', '<Left>', { desc = 'Move left' })
map('i', '<C-l>', '<Right>', { desc = 'Move right' })
map('i', '<C-j>', '<Down>', { desc = 'Move down' })
map('i', '<C-k>', '<Up>', { desc = 'Move up' })

-- ============================================================================
-- Visual mode
-- ============================================================================

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('v', '>', '>gv', { desc = 'Indent right' })
map('v', '<', '<gv', { desc = 'Indent left' })

map('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- ============================================================================
-- Tab width switcher
-- ============================================================================

map('n', '<leader>ts', function()
  local size = vim.bo.tabstop == 4 and 2 or 4
  vim.bo.tabstop = size
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end, { desc = 'Toggle tab width (2 / 4)' })

-- ============================================================================
-- UI toggles
-- ============================================================================

map('n', '<leader>ur', '<cmd>set rnu!<CR>', { desc = 'Toggle relative numbers' })

map('n', '<leader>uc', function()
  if vim.wo.colorcolumn:find '80' then
    vim.cmd 'set colorcolumn-='
  else
    vim.cmd 'set colorcolumn=80'
  end
end, { desc = 'Toggle colorcolumn at 80' })

-- ============================================================================
-- Comments (Comment.nvim compatible)
-- ============================================================================

map('n', '<leader>/', 'gcc', { desc = 'Toggle comment line', remap = true })
map('v', '<leader>/', 'gc', { desc = 'Toggle comment selection', remap = true })

-- ============================================================================
-- NvChad / UI
-- ============================================================================

map('n', '<leader>nth', function()
  require('nvchad.themes').open()
end, { desc = 'Open NvChad themes' })

map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', {
  desc = 'NvChad cheatsheet',
})

-- ============================================================================
-- WhichKey
-- ============================================================================

map('n', '<leader>wK', '<cmd>WhichKey<CR>', {
  desc = 'WhichKey: all mappings',
})

map('n', '<leader>wk', function()
  vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'WhichKey: query' })
