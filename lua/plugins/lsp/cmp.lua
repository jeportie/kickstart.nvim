return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      -- snippet plugin
      'L3MON4D3/LuaSnip',
      dependencies = 'rafamadriz/friendly-snippets',
      opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
      config = function(_, opts)
        require('luasnip').config.set_config(opts)
        require 'plugin_config.luasnip'
      end,
    },

    -- cmp sources plugins
    {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'https://codeberg.org/FelipeLema/cmp-async-path.git',
      'hrsh7th/cmp-cmdline', -- cmdline source
      'hrsh7th/cmp-calc', -- calculator source
      'hrsh7th/cmp-emoji', -- emoji source
      'uga-rosa/cmp-dictionary', -- dictionary source
      'hrsh7th/cmp-nvim-lsp-signature-help', -- signature help
      'hrsh7th/cmp-omni', -- omnifunc source
    },
  },
  opts = function()
    return require 'plugin_config.cmp'
  end,
}
