return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = false })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
    },
    -- prefer project-local prettier over global
    formatters = {
      prettier = {
        require_cwd = true,
      },
    },
  },
}
