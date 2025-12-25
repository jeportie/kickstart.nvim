local M = {}

M.keys = {
  { '<C-x>', '<C-\\><C-N>', mode = 't', desc = 'Exit terminal mode' },

  {
    '<A-v>',
    function()
      require('nvchad.term').toggle { pos = 'vsp', id = 'vtoggleTerm' }
    end,
    mode = { 'n', 't' },
    desc = 'Terminal (vertical toggle)',
  },

  {
    '<A-i>',
    function()
      require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }
    end,
    mode = { 'n', 't' },
    desc = 'Terminal (float toggle)',
  },

  {
    '<leader>tt',
    function()
      require('snacks').terminal.toggle(nil, {
        win = {
          position = 'float',
          border = 'rounded',
          width = 0.9,
          height = 0.9,
          backdrop = false,
          style = 'terminal',
        },
      })
    end,
    desc = 'Terminal (float)',
  },
}

return M
