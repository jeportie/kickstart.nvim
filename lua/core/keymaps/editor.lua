local map = vim.keymap.set
local global = vim.g

local vimKeymap = vim.keymap.set
local nvimKeymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

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

-- Scrolling and centering
opts.desc = 'Automatically centers when C-d'
nvimKeymap('n', '<C-d>', '<C-d>zz', opts)

opts.desc = 'Automatically centers when C-u'
nvimKeymap('n', '<C-u>', '<C-u>zz', opts)

opts.desc = 'Cursor follows downscoll'
vim.keymap.set('n', '<C-e>', '<C-e>j', opts)

opts.desc = 'Cursor follows upscoll'
vim.keymap.set('n', '<C-y>', '<C-y>k', opts)

opts.desc = 'Center when searching'
nvimKeymap('n', 'n', 'nzzzv', opts)
nvimKeymap('n', 'N', 'Nzzzv', opts)

-- Search and replace
opts.desc = 'Select word (\\v<..>)'
vimKeymap('n', '<leader>rs', '/\\v<><Left>', { desc = opts.desc })

nvimKeymap('n', '<leader>rw', [[:let @/='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>///g<Left><Left>]], { desc = 'Rename word under cursor' })

-- Insert mode navigation
opts.desc = 'Move up'
nvimKeymap('i', '<C-k>', '<Up>', opts)

opts.desc = 'Move down'
nvimKeymap('i', '<C-j>', '<Down>', opts)

opts.desc = 'Move left'
nvimKeymap('i', '<C-h>', '<Left>', opts)

opts.desc = 'Move right'
nvimKeymap('i', '<C-l>', '<Right>', opts)

-- Visual mode
opts.desc = 'Move selection one line down'
nvimKeymap('v', 'J', ":m '>+1<CR>gv=gv", opts)

opts.desc = 'Move selection one line up'
nvimKeymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

opts.desc = 'Indentation plus'
nvimKeymap('v', '>', '>gv', opts)

opts.desc = 'Indentation minus'
nvimKeymap('v', '<', '<gv', opts)

opts.desc = 'Keep last yanked when pasting'
nvimKeymap('v', 'p', '"_dP', opts)

-- Tab stop switcher
local function switchTabStop()
  if vim.bo.tabstop == 4 then
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  else
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end
end

vimKeymap('n', '<leader>ts', switchTabStop, { desc = 'Switch tab stop' })

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
