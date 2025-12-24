local map = vim.keymap.set

local M = {}

-- Global (non-buffered) LSP mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- Formatting (adjust to your formatter plugin)
map('n', '<leader>fm', function()
  require('conform').format { lsp_fallback = true }
end, { desc = 'Format file' })

-- LSP on_attach
function M.on_attach(_, bufnr)
  local opts = { buffer = bufnr }

  map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'LSP definition' }))
  map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'LSP declaration' }))
  map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'LSP implementation' }))
  map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP rename' }))

  map('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, vim.tbl_extend('force', opts, { desc = 'Toggle inlay hints' }))

  -- TypeScript-only tools
  if vim.bo[bufnr].filetype == 'typescript' or vim.bo[bufnr].filetype == 'typescriptreact' then
    -- Add missing imports
    map('n', '<leader>ai', '<cmd>TSToolsAddMissingImports<CR>', vim.tbl_extend('force', opts, { desc = 'Add missing imports' }))
    -- Organize imports
    map('n', '<leader>oi', '<cmd>TSToolsOrganizeImports<CR>', vim.tbl_extend('force', opts, { desc = 'Organize imports' }))
    -- Remove unused imports / vars
    map('n', '<leader>ru', '<cmd>TSToolsRemoveUnused<CR>', vim.tbl_extend('force', opts, { desc = 'Remove unused' }))
    -- Oxlint autofix (pnpm)
    map('n', '<leader>ox', function()
      vim.fn.system('pnpm oxlint --fix ' .. vim.fn.expand '%')
    end, vim.tbl_extend('force', opts, { desc = 'Oxlint fix file' }))
    -- Fix all (TS + ESLint)
    map('n', '<leader>fa', function()
      vim.cmd 'TSToolsFixAll'
      vim.wait(100)
      vim.lsp.buf.code_action {
        context = { only = { 'source.fixAll.eslint' } },
        apply = true,
      }
    end, vim.tbl_extend('force', opts, { desc = 'Fix all auto-fixable problems' }))
  end
end

return M
