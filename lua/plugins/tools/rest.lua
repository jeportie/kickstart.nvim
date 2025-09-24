return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'http')
    end,
  },
  config = function()
    require('rest-nvim').setup {
      -- your rest.nvim options here if needed
      env = {
        enable = true,
        pattern = '.*%.env.*', -- detect any `.env*` file
      },
    }

    -- load telescope extension for rest.nvim
    pcall(require('telescope').load_extension, 'rest')
  end,
}
