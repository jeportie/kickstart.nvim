-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/22 18:35:44 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 18:46:15 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local opt = vim.opt
local g   = vim.g

-- ----------------------------------- globals ------------------------------ --
g.toggle_theme_icon = "   "

-- Set to true if you have a Nerd Font installed and selected in the terminal
g.have_nerd_font = true

require 'core.init'
require('lazy').setup(require 'plugins')
require 'plugins.base64'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
