return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    keymap = { enabled = true },
    rename = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true },
    toggle = { enabled = true },
    win = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        {
          pane = 1,
          icon = ' ',
          desc = 'Browse Repo',
          key = 'b',
          padding = 1,
          action = function()
            Snacks.gitbrowse()
          end,
        },
        { section = 'startup' },
      },
    },

    picker = {
      win = {
        input = {
          keys = {
            ['<c-e>'] = { 'openInExplorer', mode = { 'n', 'i' } },
            ['<c-j>'] = { 'history_forward', mode = { 'i' } },
            ['<c-k>'] = { 'history_back', mode = { 'i' } },
            ['<c-d>'] = { 'preview_scroll_down', mode = { 'n' } },
            ['<c-u>'] = { 'preview_scroll_up', mode = { 'n' } },
          },
        },
      },
      actions = {
        openInExplorer = function(picker)
          local selected = picker:current()
          if selected and selected.file then
            require('mini.files').open(selected.file)
            picker:close()
          end
        end,
      },
    },
  },

  keys = (function()
    local keys = {}
    vim.list_extend(keys, require('core.keymaps').plugins.snacks)
    vim.list_extend(keys, require('core.keymaps').plugins.terminal)
    return keys
  end)(),
}
