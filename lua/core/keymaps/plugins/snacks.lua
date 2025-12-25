local M = {}

M.keys = {
  {
    '<leader>ff',
    function()
      require('snacks').picker.files()
    end,
    desc = 'Find files',
  },
  {
    '<leader>fw',
    function()
      require('snacks').picker.grep()
    end,
    desc = 'Find any text (live grep)',
  },
  {
    '<leader>fb',
    function()
      require('snacks').picker.buffers()
    end,
    desc = 'Find buffers',
  },
  {
    '<leader>fr',
    function()
      require('snacks').picker.lsp_references()
    end,
    desc = 'Find LSP references',
  },
  {
    '<leader>fz',
    function()
      require('snacks').picker.grep_buffers()
    end,
    desc = 'Find in open buffers',
  },
  {
    '<leader>fh',
    function()
      require('snacks').picker.help()
    end,
    desc = 'Find help pages',
  },
  {
    '<leader>fs',
    '<cmd>AutoSession search<CR>',
    desc = 'Find sessions (browse)',
  },
  {
    '<leader>fS',
    '<cmd>AutoSession deletePicker<CR>',
    desc = 'Find sessions (delete)',
  },
  {
    '<localleader>f',
    function()
      require('snacks').picker.grep_word()
    end,
    desc = 'Find word under cursor (live grep)',
  },
  -- lazygit
  {
    '<leader>gg',
    function()
      require('snacks').lazygit()
    end,
    desc = 'Lazygit (Snacks)',
  },
}

return M
