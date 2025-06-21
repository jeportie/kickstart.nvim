return {
  enabled = true,
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    {
      pane    = 1,
      icon    = " ",
      desc    = "Browse Repo",
      padding = 1,
      key     = "b",
      action  = function()
        Snacks.gitbrowse()
      end,
    },
    function()
      local in_git = Snacks.git.get_root() ~= nil
      local cmds = {
        {
          icon   = " ",
          title  = "Git Status",
          cmd    = "git --no-pager diff --stat -B -M -C",
          height = 10,
        },
      }

      return vim.tbl_map(function(cmd)
        return vim.tbl_extend("force", {
          pane    = 1,
          section = "terminal",
          enabled = in_git,
          padding = 1,
          ttl     = 5 * 60,
          indent  = 3,
        }, cmd)
      end, cmds)
    end,
    { section = "startup" },
  },
}
