-- ~/.config/nvim/lua/custom/configs/null-ls.lua
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- formatting
    null_ls.builtins.formatting.clang_format,
  },
})
