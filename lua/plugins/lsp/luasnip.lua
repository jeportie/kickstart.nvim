-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   luasnip.lua                                        :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 18:31:17 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 18:31:22 by jeportie         ###   ########.fr       --
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
    require('luasnip').setup(opts)
    require 'plugin_config.luasnip' -- your existing loader for snippet files
  end,
}
