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
  bmap('n', 'gr', vim.lsp.buf.references, 'Go to references')

  -- Actions
  bmap('n', '<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
  bmap({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, '[L]SP Code [A]ction')

  -- Hover / signature
  bmap('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
  bmap('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

  -- Inlay hints (0.10 / 0.11 safe)
  if vim.lsp.inlay_hint then
    bmap('n', '<leader>li', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
    end, '[L]SP Toggle [I]nlay hints')
  end

  -- ==========================================================================
  -- TypeScript extras (TSTools)
  -- ==========================================================================

  local ft = vim.bo[bufnr].filetype
  if ft == 'typescript' or ft == 'typescriptreact' then
    bmap('n', '<leader>li', '<cmd>TSToolsAddMissingImports<CR>', 'TS add imports')
    bmap('n', '<leader>lo', '<cmd>TSToolsOrganizeImports<CR>', 'TS organize imports')
    bmap('n', '<leader>lu', '<cmd>TSToolsRemoveUnused<CR>', 'TS remove unused')

    bmap('n', '<leader>lf', function()
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
