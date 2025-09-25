return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',

    'nvim-neotest/nvim-nio',
    'lunarmodules/lua-mimetypes', -- using this instead
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
        enabled = false,
      },
      env = {
        enable = true,
        pattern = '.*%.env.*',
      },
    }

    pcall(require('telescope').load_extension, 'rest')
  end,
}
