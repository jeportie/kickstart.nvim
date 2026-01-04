return {
  'nvzone/floaterm',
  dependencies = 'nvzone/volt',
  opts = {},
  cmd = 'FloatermToggle',
  keys = {
    {
      '<leader>it',
      '<cmd>FloatermToggle<CR>',
      desc = 'Toggle floating terminal',
      mode = 'n',
    },
  },
}
