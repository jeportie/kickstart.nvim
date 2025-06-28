-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   luasnip.lua                                        :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 18:31:17 by jeportie          #+#    #+#             --
--   Updated: 2025/06/28 16:24:09 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  'L3MON4D3/LuaSnip',
  version = '2.*', -- pin to the latest v2 release
  build = (function() -- enable regex support on Unix-like systems
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  dependencies = {
    'rafamadriz/friendly-snippets', -- your vscode-style snippet collection
  },
  opts = {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  },
  config = function(_, opts)
    local luasnip = require 'luasnip'
    luasnip.setup(opts)

    -- Load snippet files
    -- VSCode format
    require('luasnip.loaders.from_vscode').lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
    require('luasnip.loaders.from_vscode').lazy_load { paths = vim.g.vscode_snippets_path or '' }

    -- SnipMate format
    require('luasnip.loaders.from_snipmate').load()
    require('luasnip.loaders.from_snipmate').lazy_load { paths = vim.g.snipmate_snippets_path or '' }

    -- Lua format
    require('luasnip.loaders.from_lua').load()
    require('luasnip.loaders.from_lua').lazy_load { paths = vim.g.lua_snippets_path or '' }
  end,
}
