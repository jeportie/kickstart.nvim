return {
  'mattn/emmet-vim',
  ft = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'jsx', 'tsx' },
  init = function()
    vim.g.user_emmet_install_global = 0
    vim.g.user_emmet_mode = 'a'
    vim.g.user_emmet_leader_key = '<C-y>'
  end,
  config = function()
    -- FORCELOAD EMMET AUTOLOAD (fix NVChad issue)
    vim.cmd 'runtime! autoload/emmet.vim'

    vim.cmd [[
      autocmd FileType html,css,javascriptreact,typescriptreact,jsx,tsx EmmetInstall
    ]]

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'jsx', 'tsx' },
      callback = function()
        vim.bo.omnifunc = 'emmet#completeTag'
      end,
    })
  end,
}
