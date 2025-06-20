return { 'nvzone/volt', lazy = true }, {
  'nvzone/typr',
  dependencies = 'nvzone/volt',
  opts = {},
  cmd = { 'Typr', 'TyprStats' },
}, {
  'nvzone/menu',
  lazy = false, -- load always
  keys = {
    {
      '<C-t>',
      function()
        require('menu').open 'default'
      end,
      desc = 'Open menu (keyboard)',
    },
    {
      '<RightMouse>',
      function()
        require('menu.utils').delete_old_menus()
        vim.cmd.exec '"normal! \\<RightMouse>"'
        local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
        local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or 'default'
        require('menu').open(options, { mouse = true })
      end,
      desc = 'Open menu (mouse)',
    },
  },
}, {
  'nvzone/minty',
  cmd = { 'Shades', 'Huefy' },
}
