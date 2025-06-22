-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/21 12:03:51 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 19:04:16 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  -- General Utilities
  require 'plugins.ui',
  require 'plugins.mini',
  require 'plugins.snacks',
  require 'plugins.mason',
  require 'plugins.whichkey',
  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.volt',

  -- LSP and Autocompletion
  require 'plugins.lspconfig',
  require 'plugins.autocompletion',
  require 'plugins.treesitter',
  require 'plugins.lspsaga',
  require 'plugins.todocomments',
  require 'plugins.autopairs',
  require 'plugins.indent_line',
  require 'plugins.lint',

  -- Git and Version Control
  require 'plugins.gitsigns',
  require 'plugins.debug',

  -- Keymaps and UI Enhancements
  require 'plugins.noice',
  require 'plugins.guess-indent',
  require 'plugins.42-header',
  require 'plugins.outline',
  require 'plugins.helpview',

  -- AI Plugins
  -- require 'plugins.avante',
  -- require 'plugins.mcphub',
}
