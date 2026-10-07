-- Richer TypeScript hover: reveal the full type/interface declaration and
-- drill into nested types (the Neovim substitute for VS Code's "+/-" expandable
-- hover, which the built-in vim.lsp hover can't render).
--
-- Client-agnostic (uses vim.lsp.buf_request for hover/definition/signatureHelp),
-- so it works with vtsls despite the README only mentioning ts_ls.
--
-- Usage: <C-p> (normal mode) on a symbol opens the declaration window;
-- press the marked letter keys (a s b i e u r x) to drill into nested types.
return {
  "Sebastian-Nielsen/better-type-hover",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("better-type-hover").setup()
  end,
}
