return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
  },

  opts = {
    adapters = {
      ["neotest-vitest"] = {
        command = "npx vitest",

        cwd = function(path)
          -- 🔥 This is the important part
          return require("lspconfig.util").root_pattern("vitest.config.ts", "package.json", ".git")(path)
        end,
      },
    },
  },
}
