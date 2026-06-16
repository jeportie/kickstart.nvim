local layout = "float" -- "float" or "split"

local opts = {
  diff_opts = {
    layout = "vertical",
    open_in_new_tab = true,
    keep_terminal_focus = false,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = "close_window",
  },
}

if layout == "float" then
  opts.terminal = {
    snacks_win_opts = {
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      backdrop = 80,
      keys = {
        claude_hide = {
          "<A-c>",
          function(self)
            self:hide()
          end,
          mode = "t",
          desc = "Hide Claude",
        },
      },
    },
  }
end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = opts,
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  init = function()
    require("lib.claudecode_resume").setup()
    require("lib.claudecode_rules").setup()
    require("lib.claudecode_lsp").setup()
    require("lib.claudecode_review").setup()
    require("lib.claudecode_worktree").setup()
  end,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", function() require("lib.claudecode_resume").toggle() end, desc = "Toggle Claude" },
    { "<A-c>", function() require("lib.claudecode_resume").toggle() end, mode = { "n", "t" }, desc = "Toggle Claude (float)" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    { "<leader>ai", function() require("lib.claudecode_review").add_comment() end, desc = "Insert #> review comment" },
    -- In a proposed-diff buffer, <CR> resolves it: accept if no #> notes, else deny + send notes.
    -- Extras
    { "<leader>aD", function() require("lib.claudecode_extras").send_diagnostics() end, desc = "Send diagnostics" },
    { "<leader>aF", function() require("lib.claudecode_extras").send_enclosing_function() end, desc = "Send enclosing function" },
    { "<leader>ag", function() require("lib.claudecode_extras").send_git_diff() end, desc = "Send git diff" },
    { "<leader>aR", function() require("lib.claudecode_extras").send_slash("review") end, desc = "/review" },
    { "<leader>aT", function() require("lib.claudecode_extras").send_slash("test") end, desc = "/test" },
    { "<leader>aE", function() require("lib.claudecode_extras").send_slash("explain") end, desc = "/explain" },
    -- Rules & context
    { "<leader>au", function() require("lib.claudecode_rules").pick() end, desc = "Pick Claude rules file" },
    { "<leader>aL", function() require("lib.claudecode_lsp").send_context() end, desc = "Send LSP context" },
    -- Worktree cockpit
    { "<leader>aw", function() require("lib.claudecode_worktree").pick() end, desc = "Worktree cockpit" },
    { "<leader>aj", function() require("lib.claudecode_worktree").jump_to_pending() end, desc = "Jump to pending Claude" },
  },
}