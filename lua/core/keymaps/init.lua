require 'core.keymaps.mappings'

-- lua/core/keymaps/init.lua
require 'core.keymaps.leader'
require 'core.keymaps.editor'
require 'core.keymaps.windows'
require 'core.keymaps.buffers'
require 'core.keymaps.files'
require 'core.keymaps.git'
require 'core.keymaps.terminal'
require 'core.keymaps.testing'

local M = {}

-- exported helpers for plugin configs
M.lsp_on_attach = require('core.keymaps.lsp').on_attach
M.whichkey_groups = require('core.keymaps.whichkey').setup

-- exported plugin key tables (used by lazy specs)
M.plugins = {
  snacks = require('core.keymaps.plugins.snacks').keys,
  telescope = require('core.keymaps.plugins.telescope').keys,
  lspsaga = require('core.keymaps.plugins.lspsaga').keys,
  flash = require('core.keymaps.plugins.flash').keys,
  conform = require('core.keymaps.plugins.conform').keys,
}

return M
