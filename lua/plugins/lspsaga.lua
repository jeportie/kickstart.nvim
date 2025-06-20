return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach', -- loads when an LSP client attaches (requires lazy.nvim 2023‑July‑9 or later)
  ft = { 'c', 'cpp', 'lua', 'rust', 'go' }, -- loads when one of these filetypes is opened
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for icons in UI
    'neovim/nvim-lspconfig', -- ensures lspsaga is a dependency of your LSP setup
    'nvim-treesitter/nvim-treesitter', -- optional, for better UI integration
  },
  config = function()
    require('lspsaga').setup {
      -- Your lspsaga configuration options go here.
    }
  end,
}
