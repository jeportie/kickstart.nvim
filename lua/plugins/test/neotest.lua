return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "orjangj/neotest-ctest",
    "haydenmeade/neotest-jest",
    {
      "thenbe/neotest-playwright",
      dependencies = { "nvim-telescope/telescope.nvim" },
    },
    "jeportie/ledger.nvim",
  },

  opts = function(_, opts)
    return require("ledger.neotest").apply(opts)
  end,

  config = function(_, opts)
    require("neotest").setup(opts)
    require("ledger.neotest").register_commands()
  end,
}