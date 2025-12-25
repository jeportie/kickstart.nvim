return {
  'echasnovski/mini.indentscope',
  event = { 'BufReadPost', 'BufNewFile' },

  opts = function()
    local indentscope = require 'mini.indentscope'

    return {
      symbol = '│',
      options = {
        try_as_border = true,
      },
      draw = {
        animation = indentscope.gen_animation.linear { easing = 'in', unit = 'total', duration = 80 },
      },
    }
  end,

  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'help',
        'alpha',
        'dashboard',
        'neo-tree',
        'NvimTree',
        'Trouble',
        'lazy',
        'mason',
        'mini-files',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
