-- lua/plugins/lsp/tailwind.lua
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
