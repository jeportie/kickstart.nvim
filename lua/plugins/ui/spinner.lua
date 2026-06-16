return {
  "xieyonn/spinner.nvim",
  config = function()
    ---@type spinner
    local sp = require("spinner")

    -- NO need to call setup() if you are fine with defaults.
    sp.setup()
  end,
}
