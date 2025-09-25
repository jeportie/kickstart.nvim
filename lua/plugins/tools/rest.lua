return {
  'rest-nvim/rest.nvim',
  build = false, -- 🚫 disables any build/install step
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('rest-nvim').setup {
      rocks = {
        enabled = false,
        hererocks = false,
      },
      env = {
        enable = true,
        pattern = '.*%.env.*',
      },
    }
    pcall(require('telescope').load_extension, 'rest')
  end,
}
