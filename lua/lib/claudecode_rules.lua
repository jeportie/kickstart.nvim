local M = {}

local notify_on_save = true -- send Claude a note when a CLAUDE*.md file is saved

local function project_root()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    return git_root
  end
  return vim.fn.getcwd()
end

local function paths()
  local root = project_root()
  return {
    { key = "global", label = "Global rules (~/.claude/CLAUDE.md)", path = vim.fn.expand("~/.claude/CLAUDE.md") },
    { key = "project", label = "Project rules (CLAUDE.md)", path = root .. "/CLAUDE.md" },
    { key = "local", label = "Local rules (CLAUDE.local.md, gitignored)", path = root .. "/CLAUDE.local.md" },
  }
end

local function file_exists(p)
  return vim.fn.filereadable(p) == 1
end

local function open_in_split(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) ~= 1 then
    vim.fn.mkdir(dir, "p")
  end
  vim.cmd("vsplit " .. vim.fn.fnameescape(path))
end

---Show a picker of rules files. Marks existing files with ✓, missing with +.
function M.pick()
  local items = paths()
  vim.ui.select(items, {
    prompt = "Claude rules",
    format_item = function(item)
      local marker = file_exists(item.path) and "✓" or "+"
      return string.format("%s  %s", marker, item.label)
    end,
  }, function(choice)
    if not choice then
      return
    end
    open_in_split(choice.path)
  end)
end

---Close the Claude terminal and reopen with --continue so newly-edited
---rules files are picked up on spawn.
function M.reload()
  pcall(vim.cmd, "ClaudeCodeClose")
  vim.defer_fn(function()
    vim.cmd("ClaudeCode --continue")
  end, 300)
end

function M.setup()
  vim.api.nvim_create_user_command("ClaudeRulesReload", function()
    M.reload()
  end, { desc = "Restart Claude (--continue) to pick up rules changes" })

  if not notify_on_save then
    return
  end

  local grp = vim.api.nvim_create_augroup("ClaudeCodeRulesNotify", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = grp,
    pattern = { "CLAUDE.md", "CLAUDE.local.md", "*/CLAUDE.md", "*/CLAUDE.local.md" },
    callback = function(args)
      local cc_ok, claudecode = pcall(require, "claudecode")
      if not cc_ok or not (claudecode.is_claude_connected and claudecode.is_claude_connected()) then
        return
      end
      local extras_ok, extras = pcall(require, "lib.claudecode_extras")
      if not extras_ok then
        return
      end
      local fname = vim.fn.fnamemodify(args.file, ":~")
      extras.send_text(
        string.format("I just updated %s. Please re-read it via your file tools before continuing.\n", fname)
      )
    end,
  })
end

return M
