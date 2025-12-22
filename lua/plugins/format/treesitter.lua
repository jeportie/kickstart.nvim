-- lua/plugins/format/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },

  config = function()
    require('nvim-treesitter.configs').setup {

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
        additional_vim_regex_highlighting = { 'ruby' },
      },

      indent = {
        enable = true,
        disable = { 'ruby' },
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
  end,
}
-- There are additional nvim-treesitter modules that you can use to interact
-- with nvim-treesitter. You should go explore a few and see what interests you:
--
--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
