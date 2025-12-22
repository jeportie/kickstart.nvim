-- dofile(vim.g.base46_cache .. 'telescope')

return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'regex' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      use_languagetree = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },

    -- 1. Folding with Tree-sitter
    fold = {
      enable = true,
    },

    -- 2. Incremental Selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },

    -- 3. Text Objects
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },

    -- 4. Playground for Queries
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = false,
    },

    -- 5. Rainbow Delimiters
    rainbow = {
      enable = true,
      extended_mode = true,
    },

    -- 6. Refactoring Tools
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
      smart_rename = {
        enable = true,
        keymaps = { smart_rename = 'grr' },
      },
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
