-- lua/plugins/format/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',

  dependencies = {
    'windwp/nvim-ts-autotag',
  },

  config = function()
    local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
    if not ok then
      return
    end

    treesitter.setup {
      ensure_installed = {
        -- Core / 42
        'c',
        'bash',
        -- Neovim
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
        'query',
        -- Web / Frontend
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx',
        -- Backend / Config
        'json',
        'yaml',
        'toml',
        'dockerfile',
        -- Docs / Misc
        'markdown',
        'markdown_inline',
        'regex',
        'diff',
      },

      auto_install = true,

      highlight = {
        enable = true,
        use_languagetree = true,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
    }

    require('nvim-ts-autotag').setup {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    }
  end,
}
