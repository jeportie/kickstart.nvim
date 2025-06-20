return {
  {
    'NMAC427/guess-indent.nvim',
    opts = require 'plugins.guess-indent',
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = require 'plugins.gitsigns',
  },
  {
    require 'plugins.whichkey',
  },
  {
    require 'plugins.telescope',
  },
  {
    require 'plugins.lazydev',
  },
  {
    require 'plugins.lspconfig',
  },
  {
    require 'plugins.autoformat',
  },
  {
    require 'plugins.autocompletion',
  },
  {
    require 'plugins.tokyonight',
  },
  {
    require 'plugins.todocomments',
  },
  {
    require 'plugins.mini',
  },
  {
    require 'plugins.treesitter',
  },
  -- {
  --   ui = {
  --     -- If you are using a Nerd Font: set icons to an empty table which will use the
  --     -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
  --     icons = vim.g.have_nerd_font and {} or {
  --       cmd = '⌘',
  --       config = '🛠',
  --       event = '📅',
  --       ft = '📂',
  --       init = '⚙',
  --       keys = '🗝',
  --       plugin = '🔌',
  --       runtime = '💻',
  --       require = '🌙',
  --       source = '📄',
  --       start = '🚀',
  --       task = '📌',
  --       lazy = '💤 ',
  --     },
  --   },
  -- },
}
