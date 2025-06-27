-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   blink.lua                                          :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/27 10:56:27 by jeportie          #+#    #+#             --
--   Updated: 2025/06/27 12:00:59 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

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
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
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
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'cmdline',
          'calc',
          'emoji',
          'dictionary',
          'omni',
        },

        providers = {
          cmdline = { name = 'cmdline', module = 'blink.compat.source' },
          calc = { name = 'calc', module = 'blink.compat.source' },
          emoji = { name = 'emoji', module = 'blink.compat.source' },
          dictionary = { name = 'dictionary', module = 'blink.compat.source' },
          omni = { name = 'omni', module = 'blink.compat.source' },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      snippets = { preset = 'luasnip' },
    },
  },
}
