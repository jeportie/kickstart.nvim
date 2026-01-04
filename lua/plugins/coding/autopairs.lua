-- lua/plugins/coding/autopairs.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- Treesitter-aware
    enable_check_bracket_line = false,
  },
}
