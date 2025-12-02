return {
  'mattn/emmet-vim',
  lazy = false, -- 🚨 load immediately
  config = function()
    vim.g.user_emmet_leader_key = '<C-e>'
    vim.g.user_emmet_mode = 'inv'
  end,
}
