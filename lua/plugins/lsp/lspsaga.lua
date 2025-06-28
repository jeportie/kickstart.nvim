return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { '<leader>fp', '<Cmd>Lspsaga peek_definition<CR>', desc = '[f]loat [p]eek def' },
    { '<leader>fi', '<Cmd>Lspsaga incoming_calls<CR>', desc = '[f]loat [i]ncoming' },
    { '<leader>fo', '<Cmd>Lspsaga outgoing_calls<CR>', desc = '[f]loat [o]utgoing' },
    { '<leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = '[c]ode [a]ction' },
    -- you can also add your diag keys here to lazy-load on those presses:
    { '<CR>', '<Cmd>Lspsaga show_cursor_diagnostics<CR>', desc = '[s]how [c]ursor diag' },
    { '<leader>sl', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = '[s]how [l]ine diag' },
    { '<leader>sb', '<Cmd>Lspsaga show_buf_diagnostics<CR>', desc = '[s]how [b]uffer diag' },
    { '<leader>sw', '<Cmd>Lspsaga show_workspace_diagnostics<CR>', desc = '[s]how [w]orkspace diags' },
    { '[e', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'prev [e]rror' },
    { ']e', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'next [e]rror' },
  },
  config = function()
    require('lspsaga').setup {}
  end,
}
