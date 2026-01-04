local map = vim.keymap.set

local M = {}

-- ============================================================================
-- LSP on_attach (buffer-local)
-- ============================================================================

function M.on_attach(_, bufnr)
  local opts = { buffer = bufnr }

  local function bmap(mode, lhs, rhs, desc)
    map(mode, lhs, rhs, vim.tbl_extend('force', opts, { desc = desc }))
  end

  -- ==========================================================================
  -- TypeScript extras (TSTools)
  -- ==========================================================================

  local ft = vim.bo[bufnr].filetype
  if ft == 'typescript' or ft == 'typescriptreact' then
    bmap('n', '<leader>cti', '<cmd>TSToolsAddMissingImports<CR>', 'TS add imports')
    bmap('n', '<leader>cto', '<cmd>TSToolsOrganizeImports<CR>', 'TS organize imports')
    bmap('n', '<leader>ctu', '<cmd>TSToolsRemoveUnused<CR>', 'TS remove unused')

    bmap('n', '<leader>ctf', function()
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
