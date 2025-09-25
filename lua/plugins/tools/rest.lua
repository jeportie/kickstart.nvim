return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',

    -- add these to avoid luarocks
    'nvim-neotest/nvim-nio',
    'wilriker/mimetypes',
    'KaiKratz/xml2lua', -- maintained fork
    'j-hui/fidget.nvim',

    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'http')
    end,
  },
  config = function()
    require('rest-nvim').setup {
      rocks = {
        enabled = false, -- stop luarocks completely
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
