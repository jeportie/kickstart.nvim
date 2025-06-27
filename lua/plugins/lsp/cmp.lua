-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   cmp.lua                                            :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/27 13:11:32 by jeportie          #+#    #+#             --
--   Updated: 2025/06/27 13:26:28 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

dofile(vim.g.base46_cache .. 'cmp')

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
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
    local cmp = require 'cmp'
    return {
      completion = { completeopt = 'menu,menuone' },

      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),

        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },

        ['<Down>'] = cmp.mapping {
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            else
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            else
              fallback()
            end
          end,
        },
        ['<Up>'] = cmp.mapping {
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
            else
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
            else
              fallback()
            end
          end,
        },
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' }, -- function signature help
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'nvim_lua' },
        { name = 'path' },
        { name = 'calc' }, -- calculator source
        { name = 'emoji' }, -- emoji completions
        { name = 'dictionary' }, -- spell/dictionary words
        { name = 'cmdline' }, -- cmdline (requires cmp-cmdline)
        { name = 'omni' }, -- Vim's omnifunc source
      },
    }
  end,
}
