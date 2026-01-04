return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'LspAttach',

  keys = {
    { '<CR>',       '<Cmd>Lspsaga show_cursor_diagnostics<CR>',    desc = '[s]how [c]ursor diag' },
    { '<leader>cD', '<Cmd>Lspsaga show_line_diagnostics<CR>',      desc = '[s]how [l]ine diag' },
    { '<leader>cb', '<Cmd>Lspsaga show_buf_diagnostics<CR>',       desc = '[s]how [b]uffer diag' },
    { '<leader>cw', '<Cmd>Lspsaga show_workspace_diagnostics<CR>', desc = '[s]how [w]orkspace diags' },
    { '<leader>ce', '<Cmd>Lspsaga code_action<CR>',                desc = '[c]ode [a]ction' },
    { '<leader>ck', '<Cmd>Lspsaga hover_doc<CR>',                  mode = { 'n', 'i' },              desc = 'Saga [H]over Doc' },
    { '<leader>co', '<Cmd>Lspsaga outline<CR>',                    desc = '[S]aga [O]utline' },
    { '<leader>rr', '<Cmd>Lspsaga rename<CR>',                     desc = '[R]ename [E]lement' },
    { '<leader>cp', '<Cmd>Lspsaga peek_definition<CR>',            desc = '[f]loat [p]eek def' },
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
