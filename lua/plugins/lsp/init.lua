-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 12:26:32 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 18:44:57 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  require 'lua.plugins.lsp.lspconfig',
  require 'lua.plugins.lsp.lspsaga',
  require 'lua.plugins.lsp.cmp',
  require 'lua.plugins.lsp.autocompletion',
  require 'lua.plugins.lsp.lazydev',
  require 'lua.plugins.lsp.luasnip',
}
