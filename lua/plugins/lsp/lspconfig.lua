return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- ==========================================================================
    -- LSP attach: highlights only (NO keymaps here)
    -- ==========================================================================

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('core-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        local function client_supports(method)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, event.buf)
          else
            return client.supports_method(method, { bufnr = event.buf })
          end
        end

        if client_supports(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local grp = vim.api.nvim_create_augroup('core-lsp-highlight', { clear = false })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = grp,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = grp,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = event.buf,
            group = vim.api.nvim_create_augroup('core-lsp-detach', { clear = true }),
            callback = function()
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = grp, buffer = event.buf }
            end,
          })
        end
      end,
    })

    -- ==========================================================================
    -- Diagnostics UI
    -- ==========================================================================

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
      },
    }

    -- ==========================================================================
    -- Servers
    -- ==========================================================================

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local on_attach = require('core.keymaps').lsp_on_attach

    local servers = {
      clangd = {},
      bashls = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      eslint = {
        settings = {
          workingDirectories = { mode = 'auto' },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = {
              disable = { 'missing-fields' },
              globals = { 'vim' },
            },
          },
        },
      },
    }

    for name, cfg in pairs(servers) do
      vim.lsp.config(name, {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = cfg.settings,
      })
    end
  end,
}
