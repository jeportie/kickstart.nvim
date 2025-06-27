-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   mappings.lua                                       :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/22 19:55:03 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 19:55:05 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Remap ";" in normal mode to enter command mode
map('n', ';', ':', { desc = 'Enter command mode' })

-- Map "jk" in insert mode to exit to normal mode
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

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
map('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'toggle line number' })
map('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'toggle relative number' })

-- Comment
-- map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })

map('n', '<leader>wk', function()
  vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'whichkey query lookup' })

-- Key mappings for setting the colorcolumn
vim.keymap.set('n', '<Leader>cc', ':set colorcolumn=80<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ncc', ':set colorcolumn-=80<CR>', { noremap = true, silent = true })

-- map('n', '<leader>fm', function()
--   require('plugins.').format { lsp_fallback = true }
-- end, { desc = 'general format file' })

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- tabufline
map('n', '<leader>tb', '<cmd>enew<CR>', { desc = 'buffer new' })

map('n', '<tab>', function()
  require('nvchad.tabufline').next()
end, { desc = 'buffer goto next' })

map('n', '<S-tab>', function()
  require('nvchad.tabufline').prev()
end, { desc = 'buffer goto prev' })

map('n', '<leader>x', function()
  require('nvchad.tabufline').close_buffer()
end, { desc = 'buffer close' })

-- terminal
map('t', '<C-x>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

-- new terminals
map('n', '<leader>h', function()
  require('nvchad.term').new { pos = 'sp' }
end, { desc = 'terminal new horizontal term' })

map('n', '<leader>v', function()
  require('nvchad.term').new { pos = 'vsp' }
end, { desc = 'terminal new vertical term' })

-- toggleable
map({ 'n', 't' }, '<A-v>', function()
  require('nvchad.term').toggle { pos = 'vsp', id = 'vtoggleTerm' }
end, { desc = 'terminal toggleable vertical term' })

map({ 'n', 't' }, '<A-h>', function()
  require('nvchad.term').toggle { pos = 'sp', id = 'htoggleTerm' }
end, { desc = 'terminal toggleable horizontal term' })

map({ 'n', 't' }, '<A-i>', function()
  require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }
end, { desc = 'terminal toggle floating term' })

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- nvchad
map('n', '<leader>th', function()
  require('nvchad.themes').open()
end, { desc = 'telescope nvchad themes' })

map('n', '<leader>ch', ':NvCheatsheet<CR>', { noremap = true, silent = true })

map('n', '<leader>DB', function()
  require('snacks.dashboard').open()
end, {
  noremap = true,
  silent = true,
  desc = 'Toggle Dashboard ⟷ Last Buffer',
})

-- Lspsaga
map('n', 'pd', '<Cmd>Lspsaga peek_definition<CR>', { buffer = true, silent = true })
