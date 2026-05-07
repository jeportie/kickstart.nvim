vim.api.nvim_create_user_command("ScrollDbg", function(opts)
  local sub = opts.fargs[1] or "report"
  local sd = require("scrolldbg")
  local action = sd[sub]
  if type(action) ~= "function" then
    vim.notify("ScrollDbg: unknown subcommand '" .. sub .. "'", vim.log.levels.ERROR)
    return
  end
  action()
end, {
  nargs = "?",
  complete = function() return { "start", "stop", "report", "snapshot", "reset", "tail" } end,
  desc = "Window-shift diagnostic logger",
})
