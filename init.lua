-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/22 18:35:44 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 19:48:11 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local g = vim.g

-- ----------------------------------- globals ------------------------------ --
g.toggle_theme_icon = '   '
g.have_nerd_font = true

require 'core.init'
require('lazy').setup(require 'plugins')
require 'base64'
