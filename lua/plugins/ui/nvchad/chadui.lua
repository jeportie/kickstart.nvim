return {
  'nvim-lua/plenary.nvim',
  {
    'nvim-tree/nvim-web-devicons',
    opts = function()
      dofile(vim.g.base46_cache .. 'devicons')
      return { override = require 'nvchad.icons.devicons' }
    end,
  },
  {
    'nvchad/ui',
    lazy = false,
    config = function()
      require 'nvchad'
    end,
  },
  {
    'nvchad/base46',
    build = function()
      require('base46').load_all_highlights()
    end,
  },
  'nvchad/volt',
}
