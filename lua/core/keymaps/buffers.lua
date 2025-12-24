local map = vim.keymap.set

-- tabufline
map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'buffer new' })

map('n', '<tab>', function()
  require('nvchad.tabufline').next()
end, { desc = 'buffer goto next' })

map('n', '<S-tab>', function()
  require('nvchad.tabufline').prev()
end, { desc = 'buffer goto prev' })

map('n', '<leader>bx', function()
  require('nvchad.tabufline').close_buffer()
end, { desc = 'buffer close' })
