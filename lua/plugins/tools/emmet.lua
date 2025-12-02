return {
  'mattn/emmet-vim',
  ft = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
  init = function()
    -- Make <Tab> expand Emmet in insert mode only when appropriate
    vim.g.user_emmet_leader_key = '<C-e>'
  end,
}
