local Snacks = require 'snacks'

local M = {}

M.keys = {
  {
    '<leader>ff',
    function()
      Snacks.picker.files()
    end,
    desc = 'Find files',
  },
  {
    '<leader>fw',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Find any text (live grep)',
  },
  {
    '<leader>fb',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Find buffers',
  },
  {
    '<leader>fr',
    function()
      Snacks.picker.lsp_references()
    end,
    desc = 'Find LSP references',
  },
  {
    '<leader>fz',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Find in open buffers',
  },
  {
    '<leader>fh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Find help pages',
  },
  {
    '<leader>fs',
    function()
      vim.cmd 'AutoSession search'
    end,
    desc = 'Find sessions (browse)',
  },
  {
    '<leader>fS',
    function()
      vim.cmd 'AutoSession deletePicker'
    end,
    desc = 'Find sessions (delete)',
  },
  {
    '<localleader>f',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Find word under cursor (live grep)',
  },
}

return M
