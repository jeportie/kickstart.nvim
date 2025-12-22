-- dofile(vim.g.base46_cache .. 'mason')

return {
  {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile', 'VimEnter' },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'nvimtools/none-ls.nvim',
    },
    config = function()
      require('mason').setup {
        max_concurrent_installers = 10,
        ui = {
          icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ',
          },
        },
      }
      require('mason-lspconfig').setup {
        automatic_installation = true, -- Automatically install missing LSP servers
      }
      require('mason-tool-installer').setup {
        ensure_installed = {
          -- we’ll fill this in from your lspconfig.lua
          'stylua',
          -- add more CLI tools here if desired
        },
      }
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = {
          'codelldb',
          'bash-debug-adapter',
          -- add other debug adapters here
        },
      }
    end,
  },
}
