local M = {}

M.keys = {
  { '<leader>ff', '<Cmd>Lspsaga finder<CR>', desc = '[f]loat lsp [f]inder' },
  { '<leader>fp', '<Cmd>Lspsaga peek_definition<CR>', desc = '[f]loat [p]eek def' },
  { '<leader>fi', '<Cmd>Lspsaga incoming_calls<CR>', desc = '[f]loat [i]ncoming' },
  { '<leader>fo', '<Cmd>Lspsaga outgoing_calls<CR>', desc = '[f]loat [o]utgoing' },
  { '<leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = '[c]ode [a]ction' },
  { '<CR>', '<Cmd>Lspsaga show_cursor_diagnostics<CR>', desc = '[s]how [c]ursor diag' },
  { '<leader>sl', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = '[s]how [l]ine diag' },
  { '<leader>sb', '<Cmd>Lspsaga show_buf_diagnostics<CR>', desc = '[s]how [b]uffer diag' },
  { '<leader>sw', '<Cmd>Lspsaga show_workspace_diagnostics<CR>', desc = '[s]how [w]orkspace diags' },
  { '[e', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'prev [e]rror' },
  { ']e', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'next [e]rror' },
  { '<A-t>', '<Cmd>Lspsaga term_toggle<CR>', mode = { 'n', 't' }, silent = true, desc = '[t]oggle [t]erminal' },
  { '<leader>K', '<Cmd>Lspsaga hover_doc<CR>', mode = { 'n', 'i' }, desc = 'Saga [H]over Doc' },
  { '<leader>so', '<Cmd>Lspsaga outline<CR>', desc = '[S]aga [O]utline' },
  { '<leader>re', '<Cmd>Lspsaga rename<CR>', desc = '[R]ename [E]lement' },
}

return M
