return {
  {
    'NvChad/nvterm',
    enabled = true,

    keys = {
      -- Exit terminal mode
      { '<C-x>', '<C-\\><C-N>',                  mode = 't',          desc = 'Exit terminal mode' },

      { '<A-i>', '<Cmd>Lspsaga term_toggle<CR>', mode = { 'n', 't' }, desc = 'Terminal (float toggle)', },

      -- Floating terminal
      {
        '<A-t>',
        function()
          require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }
        end,
        mode = { 'n', 't' },
        desc = 'Terminal (float toggle)',
      },
    },
  },
}
