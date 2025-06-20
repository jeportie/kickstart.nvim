-- [[ Basic Autocommands ]]
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Set the CursorHold trigger time to 2000ms (2 seconds)
vim.o.updatetime = 1500

-- Show LSP hover after idle
autocmd('CursorHold', {
  pattern = '*',
  callback = function()
    if vim.lsp.buf.hover then
      vim.lsp.buf.hover()
    end
  end,
})

-- Automatically close any floating hover window when the cursor moves.
autocmd('CursorMoved', {
  pattern = '*',
  callback = function()
    if vim.lsp and vim.lsp.util and vim.lsp.util.close_floating_preview then
      vim.lsp.util.close_floating_preview()
    end
  end,
})
