return {
  "jeportie/ledger.nvim",
  dir = vim.fn.expand("~/src/ledger.nvim"),
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvzone/volt",
    "nvzone/menu",
  },
  lazy = false,
  priority = 100,
  config = function()
    require("ledger").setup({
      jira = { project_key = "QAA", board_name = "Team QA Automation" },
      xray = { project_key = "B2CQA" },
    })

    vim.keymap.set("n", "<leader>jb", function()
      require("ledger.jira.board").open()
    end, { desc = "Jira board (QA Automation)" })

    vim.keymap.set("n", "<leader>fx", function()
      require("ledger.xray").search()
    end, { desc = "Xray: find B2CQA tickets" })

    vim.keymap.set("n", "<leader>xc", function()
      require("ledger.xray").coverage()
    end, { desc = "Xray: coverage stats (desktop/mobile)" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "xray", "neotest-summary" },
      callback = function(args)
        vim.b[args.buf].miniindentscope_disable = true
      end,
    })
  end,
}