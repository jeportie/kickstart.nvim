return {
  '42Paris/42header',
  keys = {
    { '<F1>', '<cmd>Stdheader<CR>', desc = 'Insert 42 Header' },
  },
  config = function()
    vim.cmd [[
        let g:user42 = 'jeportie'
        let g:mail42 = 'jeportie@student.42.fr'
      ]]
  end,
}
