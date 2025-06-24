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
  require 'plugins.guess-indent',
  require 'plugins.42-header',

  -- LSP and Autocompletion
  require 'plugins.lsp',
  require 'plugins.treesitter',
  require 'plugins.autopairs',

  -- Git and Version Control
  require 'plugins.gitsigns',
  require 'plugins.debug',

  -- Keymaps and UI Enhancements
  require 'plugins.ui',
  require 'plugins.volt',
  require 'plugins.nvimtree',
  require 'plugins.noice',
  require 'plugins.outline',
  require 'plugins.helpview',
  require 'plugins.indent_line',
  require 'plugins.todocomments',

  -- AI Plugins
  -- require 'plugins.avante',
  -- require 'plugins.mcphub',
}
