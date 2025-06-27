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
    -- 2. Add your buffer-local keymap for peek_definition
    --    We're using vim.keymap.set; if you have a 'map' wrapper, swap this out accordingly.
    vim.keymap.set('n', '<leader>dp', '<Cmd>Lspsaga peek_definition<CR>', { buffer = true, silent = true })
  end,
}
