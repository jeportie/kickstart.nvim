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
      -- Point the builder at your local ledger-live checkout so build/test
      -- tasks resolve even when nvim's cwd is elsewhere.
      monorepo_root = "~/src/tries/2026-04-08-LedgerHQ-ledger-live",
    })

    vim.keymap.set("n", "<leader>jb", function()
      require("ledger.jira.board").open()
    end, { desc = "Jira board (QA Automation)" })

    -- Ledger-live suite lives under <leader>l (see <leader>p for Lazy).
    pcall(function()
      require("which-key").add({ { "<leader>l", group = "+ledger" } })
    end)

    vim.keymap.set("n", "<leader>lb", function()
      require("ledger.builder").toggle()
    end, { desc = "Ledger Builder dashboard" })

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