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
  require 'plugins.lsp.lspconfig',
  require 'plugins.lsp.lspsaga',
  -- require 'plugins.lsp.cmp',
  require 'plugins.lsp.blink',
  require 'plugins.lsp.lazydev',
  require 'plugins.lsp.luasnip',
}
