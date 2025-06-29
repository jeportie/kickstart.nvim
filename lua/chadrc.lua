-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

--@type ChadrcConfig
local M = {}

M.base46 = {
  theme = 'jellybeans',
  transparency = false,
}

M.ui = {
  telescope = { style = 'bordered' }, -- borderless / bordered
  statusline = {
    theme = 'default',
    -- theme = 'vscode',
    -- theme = 'vscode_colored',
    -- theme = 'minimal',
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = 'default',
    order = nil,
    modules = nil,
  },
  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { 'treeOffset', 'buffers', 'tabs', 'btns' },
    modules = nil,
    bufwidth = 21,
  },
}

return M
