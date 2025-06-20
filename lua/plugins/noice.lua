return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      signature = {
        enabled = false,
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
