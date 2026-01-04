return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
    'marilari88/neotest-vitest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        -- Registration
        require 'neotest-vitest',
        -- require 'neotest-zig' {
        --   dap = {
        --     adapter = 'lldb',
        --   },
        -- },
      },
    }
  end,
}
