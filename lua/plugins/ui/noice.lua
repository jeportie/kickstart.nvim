return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      -- tell Noice to intercept these LSP functions
      override = {
        ['vim.lsp.buf.signature_help'] = true,
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      signature = {
        enabled = true,
      },
    },
    routes = {
      {
        filter = { find = 'No information available' },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
