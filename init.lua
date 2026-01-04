--[[
  ┌────────────────────────────────────────────────────────────────────────────┐
  │                             My Neovim Config                               │
  ├────────────────────────────────────────────────────────────────────────────┤
  │  • init.lua                  ← Entry point: sets globals, loads core       │
  │  • lua/chadrc.lua            ← User overrides for UI & Base46 (themes,     │
  │                                 statusline, tabufline, etc.)               │
  │  • lua/config/               ← Core engine files: autocommands, mappings,  │
  │       ├── lazy.lua             options, health checks, lazy-installer      │
  │       ├── options.lua                                                      │
  │       ├── keymaps.lua                                                      │
  │       └── autocmds.lua                                                     │
  │  • lua/plugins/              ← Per-plugin configs, organized by feature    │
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

require("config.lazy")

-- load NVChad’s cached highlights (Base46)
for _, f in ipairs(vim.fn.readdir(g.base46_cache)) do
  dofile(g.base46_cache .. f)
end

require 'nvchad'
