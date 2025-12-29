local map = vim.keymap.set

local M = {}

-- ============================================================================
-- Global LSP / Diagnostics (non-buffered)
-- ============================================================================

map('n', '<leader>ld', vim.diagnostic.setloclist, {
  desc = '[L]SP [D]iagnostics (loclist)',
})

map('n', '<leader>lf', function()
  require('conform').format { lsp_fallback = true }
end, { desc = '[L]SP [F]ormat file' })

-- ============================================================================
-- LSP on_attach (buffer-local)
-- ============================================================================

function M.on_attach(_, bufnr)
  local opts = { buffer = bufnr }

  local function bmap(mode, lhs, rhs, desc)
    map(mode, lhs, rhs, vim.tbl_extend('force', opts, { desc = desc }))
  end

  -- Core navigation
  bmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
  bmap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
  bmap('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')

  -- Inlay hints (0.10 / 0.11 safe)
  if vim.lsp.inlay_hint then
    bmap('n', '<leader>lh', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
    end, '[L]SP Toggle Inlay [H]ints')
  end

  -- ==========================================================================
  -- TypeScript extras (TSTools)
  -- ==========================================================================

  local ft = vim.bo[bufnr].filetype
  if ft == 'typescript' or ft == 'typescriptreact' then
    bmap('n', '<leader>lti', '<cmd>TSToolsAddMissingImports<CR>', 'TS add imports')
    bmap('n', '<leader>lto', '<cmd>TSToolsOrganizeImports<CR>', 'TS organize imports')
    bmap('n', '<leader>ltu', '<cmd>TSToolsRemoveUnused<CR>', 'TS remove unused')

    bmap('n', '<leader>ltf', function()
      vim.cmd 'TSToolsFixAll'
      vim.wait(100)
      vim.lsp.buf.code_action {
        context = { only = { 'source.fixAll.eslint' } },
        apply = true,
      }
    end, 'TS fix all')
  end
end

return M
