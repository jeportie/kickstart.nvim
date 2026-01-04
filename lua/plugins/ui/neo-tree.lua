return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "left",
      width = 26,              -- 👈 important pour l’offset
      mappings = {
        ["v"] = "open_vsplit", -- 👈 vertical split
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "open_default",
    },
  },
}
