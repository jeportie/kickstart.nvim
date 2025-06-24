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
  require 'plugins.mini',
  require 'plugins.snacks',
  require 'plugins.ui',
  require 'plugins.lsp',
  require 'plugins.lint',
  require 'plugins.tools',

  -- General Utilities
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.dap',

  -- require 'plugins.ia',
  -- AI Plugins
  -- require 'plugins.ia.copyrightavante',
  -- require 'plugins.ia.mcphub',
}
