return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },

        -- root_dir = require("lspconfig.util").root_pattern(
        --   "tailwind.config.js",
        --   "tailwind.config.cjs",
        --   "tailwind.config.mjs",
        --   "tailwind.config.ts",
        --   "postcss.config.js",
        --   "package.json",
        --   ".git"
        -- ),

        settings = {
          tailwindCSS = {
            validate = true,
            classAttributes = { "class", "className", "class:list", "ngClass" },
            experimental = {
              classRegex = {
                "tw`([^`]*)",
                'tw="([^"]*)',
                'tw={"([^"}]*)',
                'class:\\s*"([^"]*)',
              },
            },
          },
        },
      },
    },
  },
}
