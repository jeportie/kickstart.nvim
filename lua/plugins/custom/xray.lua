return {
  name = "xray",
  dir = vim.fn.stdpath("config"),
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvzone/volt",
  },
  lazy = false,
  priority = 100,
  config = function()
    local xray = require("xray")
    xray.setup({
      project_key = "B2CQA",
      ledger_live_root = nil,
    })

    vim.keymap.set("n", "<leader>fx", function()
      xray.search()
    end, { desc = "Xray: find B2CQA tickets" })
    vim.keymap.set("n", "<leader>xc", function()
      xray.coverage()
    end, { desc = "Xray: coverage stats (desktop/mobile)" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "xray", "neotest-summary" },
      callback = function(args)
        vim.b[args.buf].miniindentscope_disable = true
      end,
    })
  end,
}
