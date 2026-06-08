return {
  "Alexandersfg4/environment.nvim",
  config = function()
    require("environment").setup({
      variables = {
        -- Your default variables here
        API_KEY = "default_value",
        ENV = "development",
        DISABLE_TRANSACTION_BROADCAST = "0",
      },
    })
  end,
}
