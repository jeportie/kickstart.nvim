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

--[[
  ┌────────────────────────────────────────────────────────────────────────────┐
  │                             NVChad Config                                  │
  ├────────────────────────────────────────────────────────────────────────────┤
  │  • init.lua                  ← Entry point: sets globals, loads core       │
  │  • lua/chadrc.lua            ← User overrides for UI & Base46 (themes,     │
  │                                 statusline, tabufline, etc.)               │
  │  • lua/core/                 ← Core engine files: autocommands, mappings,  │
  │       ├── init.lua             options, health checks, lazy-installer      │
  │       ├── options.lua         (loaded by init.lua)                         │
  │       ├── mappings.lua                                                     │
  │       └── autocommands.lua                                                 │
  │  • lua/plugins/              ← Per-plugin configs, organized by feature    │
  │       ├── init.lua             (formatting, LSP, UI tweaks, tools, etc.)   │
  │       ├── format/                                                          │
  │       ├── lsp/                                                             │
  │       ├── ui/                                                              │
  │       └── …                                                                │
  │                                                                            │
  │  Loading order:                                                            │
  │    1. init.lua (globals + core)                                            │
  │    2. lazy.setup(require "plugins") ← plugin specs from lua/plugins/       │
  │    3. dofile(base46_cache)    ← compiled highlight/theme files             │
  │    4. require "nvchad"        ← UI & Base46 initialization                 │
  └────────────────────────────────────────────────────────────────────────────┘
]]

local g = vim.g

-- ----------------------------------- globals ------------------------------ --
g.toggle_theme_icon = '   '
g.have_nerd_font = true

require 'core.init'
require('lazy').setup(require 'plugins')

-- load NVChad’s cached highlights (Base46)
-- g.base46_cache = vim.fn.stdpath 'data' .. '/base46_cache/'
-- dofile(g.base46_cache .. 'defaults') -- default highlights
-- dofile(g.base46_cache .. 'statusline') -- statusline highlights

-- or, to load all at once:
for _, f in ipairs(vim.fn.readdir(g.base46_cache)) do
  dofile(g.base46_cache .. f)
end

require 'nvchad'
