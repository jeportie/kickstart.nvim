return {
  "nvim-mini/mini.diff",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>go",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "Toggle git diff overlay",
    },
  },
  config = function()
    require("mini.diff").setup({
      view = {
        -- "number" tints line numbers instead of using the sign column,
        -- so it doesn't fight with gitsigns' sign column.
        style = "number",
        signs = { add = "▎", change = "▎", delete = "" },
        priority = 199,
      },
    })
  end,
}
