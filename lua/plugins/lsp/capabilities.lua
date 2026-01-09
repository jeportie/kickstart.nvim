-- lua/plugins/lsp/capabilities.lua
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local base = vim.lsp.protocol.make_client_capabilities()
    local blink = require("blink.cmp").get_lsp_capabilities()

    local capabilities = vim.tbl_deep_extend("force", base, blink, {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    })

    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].capabilities = capabilities
  end,
}
