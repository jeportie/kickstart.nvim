-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

--@type ChadrcConfig
local M = {}

M.base46 = {
  theme = 'tokyonight',
  transparency = true,
}

M.ui = {
  telescope = { style = 'bordered' }, -- borderless / bordered
  statusline = {
    theme = 'default',
    separator_style = 'default',
    order = { 'mode', 'file', 'git', '%=', 'lsp_msg', '%=', 'diagnostics', 'claude', 'lsp', 'cwd', 'cursor' },
    modules = {
      claude = function() return require('lib.claudecode_statusline').claude() end,
    },
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
