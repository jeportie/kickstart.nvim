-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/21 12:03:51 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 14:50:00 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  -- Suite
  require 'plugins.mini',
  require 'plugins.snacks',

  -- General Utilities
  require 'plugins.whichkey',
  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.42-header',

  -- LSP / DAP / FORMAT / LINT
  require 'plugins.lsp',
  require 'plugins.lint',
  require 'plugins.treesitter',
  require 'plugins.dap',

  -- Keymaps and UI Enhancements
  require 'plugins.ui',

  -- AI Plugins
  -- require 'plugins.ia.copyrightavante',
  -- require 'plugins.ia.mcphub',
}
