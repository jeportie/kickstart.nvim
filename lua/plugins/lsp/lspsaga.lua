return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'LspAttach',
  -- cmd = { 'Lspsaga' },
  keys = {
    { '<leader>ff', '<Cmd>Lspsaga finder<CR>', desc = '[f]loat lsp [f]inder' },
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
    { '<A-t>', '<Cmd>Lspsaga term_toggle<CR>', mode = { 'n', 't' }, silent = true, desc = '[t]oggle [t]erminal' },
    { '<leader>K', '<Cmd>Lspsaga hover_doc<CR>', mode = { 'n', 'i' }, desc = 'Saga [H]over Doc' },
    { '<leader>so', '<Cmd>Lspsaga outline<CR>', desc = '[S]aga [O]utline' },
    { '<leader>re', '<Cmd>Lspsaga rename<CR>', desc = '[R]ename [E]lement' },
  },
  config = function()
    require('lspsaga').setup {}
    -- after require('lspsaga').setup {} in your config:
    local saga_outline_grp = vim.api.nvim_create_augroup('SagaOutlineArrows', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = saga_outline_grp,
      -- lspsaga’s outline buffer typically uses filetype "lspsagaoutline",
      -- but if that doesn’t match, open the outline and run `:echo &filetype`
      -- and substitute the correct ft here:
      pattern = 'sagaoutline',
      callback = function(args)
        local buf = args.buf
        -- map Up → k
        vim.keymap.set('n', '<Up>', 'k', {
          buffer = buf,
          desc = 'lspsaga outline: move up',
        })
        -- map Down → j
        vim.keymap.set('n', '<Down>', 'j', {
          buffer = buf,
          desc = 'lspsaga outline: move down',
        })
      end,
    })
  end,
}
