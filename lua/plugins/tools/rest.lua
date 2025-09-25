return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',

    -- proper deps
    'nvim-neotest/nvim-nio',
    'daurnimator/lua-mimetypes',
    'manoelcampos/xml2lua',
    'j-hui/fidget.nvim',

    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'http')
    end,
  },
  config = function()
    require('rest-nvim').setup {
      rocks = {
        enabled = false, -- completely disable luarocks
      },
      env = {
        enable = true,
        pattern = '.*%.env.*',
      },
    }

    -- telescope extension
    pcall(require('telescope').load_extension, 'rest')
  end,
}
