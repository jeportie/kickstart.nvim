return {
  "NvChad/NvChad",
  lazy = false,
  priority = 10000,
  config = function()
    -- Boot NvChad framework explicitly
    require("nvchad")
  end,
}
