return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    local lsp_keys = require('config.keymaps.lsp')

    opts.on_attach = function(client, bufnr)
      lsp_keys.on_attach(client, bufnr)
    end
    -- declare non-TS servers here
    opts.servers = opts.servers or {}
    opts.servers.lua_ls = {}
    opts.servers.cssls = {}
    opts.servers.html = {}
    opts.servers.jsonls = {}

    return opts
  end,
}
