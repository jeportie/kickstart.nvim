return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers (Mason package names!)
        "css-lsp",
        "emmet-language-server",
        "eslint-lsp",
        "lua-language-server",
        "prisma-language-server",
        "tailwindcss-language-server",
        -- Formatters / tools
        "stylua",
        "prettier",
        "shellcheck",
      },
    }
  }
}
