return {
  name = "jira-board",
  dir = vim.fn.stdpath("config"),
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvzone/volt",
  },
  lazy = true,
  keys = {
    {
      "<leader>jb",
      function()
        require("jira-board").open()
      end,
      desc = "Jira board (QA Automation)",
    },
  },
  config = function()
    require("jira-board").setup({
      team = "QA Automation",
      project_key = "QAA",
    })
  end,
}
