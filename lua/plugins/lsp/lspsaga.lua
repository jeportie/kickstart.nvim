return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'LspAttach',

  keys = {
  },

  config = function()
    require('lspsaga').setup {
      lightbulb = {
        enable = false,
        enable_in_insert = true,
        sign = true,
        virtual_text = false,
      },
    }
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
