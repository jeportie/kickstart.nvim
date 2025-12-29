return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-calc',
      'uga-rosa/cmp-dictionary',
      'hrsh7th/cmp-omni',
    },
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        -- arrow keys, same as <C-p>/<C-n>
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        -- tab highjack
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 50 },
      },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'calc',
          'dictionary',
          'omni',
        },

        providers = {
          calc = { name = 'calc', module = 'blink.compat.source' },
          dictionary = { name = 'dictionary', module = 'blink.compat.source' },
          omni = { name = 'omni', module = 'blink.compat.source' },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      snippets = { preset = 'luasnip' },
    },
  },
}
