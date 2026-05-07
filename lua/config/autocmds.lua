-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function noop(_, _, _, _) end

vim.lsp.handlers["textDocument/hover"] = noop
vim.lsp.handlers["textDocument/signatureHelp"] = noop

-- Prevent scrollbind/cursorbind from leaking out of diff mode into normal splits
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if not vim.wo.diff then
      vim.wo.scrollbind = false
      vim.wo.cursorbind = false
    end
  end,
})
