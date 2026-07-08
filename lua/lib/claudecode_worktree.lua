-- Claude-per-worktree cockpit.
--
-- Runs multiple fully-integrated Claude sessions in parallel by giving each git
-- worktree its own nvim instance in a WezTerm tab. A snacks picker lists the
-- worktrees with live status; a per-instance daemon publishes status to a shared
-- directory so any instance can toast when another worktree's Claude proposes an
-- edit. See lua/.claude plan: claudecode-worktree-cockpit.

local M = {}

local STALE_SECONDS = 8 -- a status file older than this = instance considered dead
local POLL_MS = 2500

-- Per-instance identity, resolved in setup().
local own_worktree = nil
local own_file = nil
local own_branch = nil

local timer = nil
local last_pending = {} -- worktree path -> last observed pending_diff (for transition detection)

--------------------------------------------------------------------------------
-- WezTerm adapter (isolated so Ghostty/tmux could be swapped later)
--------------------------------------------------------------------------------

local function wez_available()
  return vim.env.WEZTERM_PANE ~= nil and vim.fn.executable("wezterm") == 1
end

---Spawn `nvim` in a new WezTerm tab rooted at cwd. Returns the new pane id, or nil.
local function wez_spawn(cwd)
  local out = vim.fn.systemlist({ "wezterm", "cli", "spawn", "--cwd", cwd, "--", "nvim" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local id = out[#out]
  return id and vim.trim(id) or nil
end

---Focus an existing WezTerm pane.
local function wez_activate(pane_id)
  vim.fn.system({ "wezterm", "cli", "activate-pane", "--pane-id", tostring(pane_id) })
  return vim.v.shell_error == 0
end

--------------------------------------------------------------------------------
-- Worktree enumeration
--------------------------------------------------------------------------------

---Parse `git worktree list --porcelain` into a list of { path, branch, head, detached, bare }.
local function list_worktrees()
  local out = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return {}
  end
  local wts = {}
  local cur = nil
  for _, line in ipairs(out) do
    if line:match("^worktree ") then
      if cur then
        table.insert(wts, cur)
      end
      cur = { path = line:sub(10) }
    elseif cur then
      if line:match("^HEAD ") then
        cur.head = line:sub(6)
      elseif line:match("^branch ") then
        cur.branch = (line:sub(8):gsub("^refs/heads/", ""))
      elseif line == "detached" then
        cur.detached = true
      elseif line == "bare" then
        cur.bare = true
      end
    end
  end
  if cur then
    table.insert(wts, cur)
  end
  return wts
end

local function detect_worktree()
  local root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
  if vim.v.shell_error ~= 0 or not root or root == "" then
    return nil
  end
  return root
end

local function current_branch(dir)
  local b = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })[1]
  if vim.v.shell_error ~= 0 or not b or b == "" then
    return nil
  end
  return b
end

--------------------------------------------------------------------------------
-- Shared status directory
--------------------------------------------------------------------------------

local function status_dir()
  return vim.fn.stdpath("data") .. "/claude_worktrees"
end

---Stable, collision-free filename for a worktree path (path is stored inside the file).
local function status_file_for(path)
  return status_dir() .. "/" .. vim.fn.sha256(path):sub(1, 16) .. ".json"
end

---Read every status file into a map: worktree path -> status table.
local function read_statuses()
  local dir = status_dir()
  local res = {}
  if vim.fn.isdirectory(dir) ~= 1 then
    return res
  end
  for _, f in ipairs(vim.fn.glob(dir .. "/*.json", false, true)) do
    local fd = io.open(f, "r")
    if fd then
      local content = fd:read("*a")
      fd:close()
      local ok, data = pcall(vim.json.decode, content)
      if ok and type(data) == "table" and data.worktree then
        res[data.worktree] = data
      end
    end
  end
  return res
end

local function is_live(st, now)
  return st and st.updated_at and (now - st.updated_at) <= STALE_SECONDS
end

---Inspect the local claudecode session without forcing the plugin to load.
---@return boolean connected, boolean pending
local function claude_state()
  local connected, pending = false, false
  if not package.loaded["claudecode"] then
    return connected, pending
  end
  local ok, cc = pcall(require, "claudecode")
  if ok and cc.is_claude_connected then
    connected = cc.is_claude_connected() and true or false
  end
  local dok, diff = pcall(require, "claudecode.diff")
  if dok and diff._get_active_diffs then
    local active = diff._get_active_diffs() or {}
    for _, d in pairs(active) do
      if d.status == "pending" then
        pending = true
        break
      end
    end
  end
  return connected, pending
end

local function write_own_status(connected, pending)
  if not own_worktree or not own_file then
    return
  end
  vim.fn.mkdir(status_dir(), "p")
  local data = {
    worktree = own_worktree,
    branch = own_branch,
    pane_id = vim.env.WEZTERM_PANE,
    pid = vim.fn.getpid(),
    claude_connected = connected and true or false,
    pending_diff = pending and true or false,
    updated_at = os.time(),
  }
  local fd = io.open(own_file, "w")
  if fd then
    fd:write(vim.json.encode(data))
    fd:close()
  end
end

--------------------------------------------------------------------------------
-- Daemon tick: refresh own status, watch others, toast on new pending edits
--------------------------------------------------------------------------------

local function tick()
  if own_worktree then
    local connected, pending = claude_state()
    write_own_status(connected, pending)
  end

  local now = os.time()
  for path, st in pairs(read_statuses()) do
    if path ~= own_worktree then
      local pend = is_live(st, now) and st.pending_diff == true
      if pend and not last_pending[path] then
        local branch = st.branch or vim.fn.fnamemodify(path, ":t")
        vim.notify(
          "✻ Claude [" .. branch .. "] proposed an edit — <leader>aj to jump",
          vim.log.levels.INFO,
          { title = "Claude worktree" }
        )
      end
      last_pending[path] = pend
    end
  end
end

local function start_timer()
  if timer then
    return
  end
  timer = vim.uv.new_timer()
  timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(tick))
end

--------------------------------------------------------------------------------
-- Cockpit actions
--------------------------------------------------------------------------------

local function open_or_focus(wt)
  if not wez_available() then
    vim.notify("WezTerm CLI not available — run inside WezTerm to launch worktrees", vim.log.levels.WARN)
    return
  end
  local now = os.time()
  local st = read_statuses()[wt.path]
  if st and st.pane_id and is_live(st, now) then
    if wez_activate(st.pane_id) then
      return
    end
  end
  local pane = wez_spawn(wt.path)
  if pane then
    vim.notify("Opened worktree: " .. (wt.branch or wt.path), vim.log.levels.INFO)
  else
    vim.notify("Failed to spawn WezTerm tab for " .. wt.path, vim.log.levels.ERROR)
  end
end

local function build_items()
  local wts = list_worktrees()
  if #wts == 0 then
    return nil
  end
  local statuses = read_statuses()
  local now = os.time()
  local items = {}
  for _, wt in ipairs(wts) do
    local st = statuses[wt.path]
    local live = is_live(st, now)
    local branch = wt.branch
    if not branch then
      if wt.detached then
        branch = "(detached " .. (wt.head and wt.head:sub(1, 7) or "?") .. ")"
      elseif wt.bare then
        branch = "(bare)"
      else
        branch = "(unknown)"
      end
    end
    items[#items + 1] = {
      text = branch .. " " .. wt.path,
      wt = wt,
      branch = branch,
      live = live,
      connected = live and st.claude_connected == true,
      pending = live and st.pending_diff == true,
      is_own = wt.path == own_worktree,
    }
  end
  return items
end

local function item_marker(item)
  if item.pending then
    return "!", "DiagnosticError"
  elseif item.connected then
    return "✻", "DiagnosticOk"
  elseif item.live then
    return "●", "DiagnosticInfo"
  end
  return " ", "Comment"
end

function M.pick()
  local items = build_items()
  if not items then
    vim.notify("No git worktrees found (not inside a git repo?)", vim.log.levels.WARN)
    return
  end

  local ok, Snacks = pcall(require, "snacks")
  if ok and Snacks and Snacks.picker then
    Snacks.picker.pick({
      title = "Claude Worktrees",
      items = items,
      layout = { preset = "select" },
      format = function(item)
        local glyph, hl = item_marker(item)
        local ret = {
          { glyph .. " ", hl },
          { item.branch, "Title" },
          { "  ", "Normal" },
          { vim.fn.fnamemodify(item.wt.path, ":~"), "Comment" },
        }
        if item.is_own then
          ret[#ret + 1] = { "  (this nvim)", "DiagnosticHint" }
        end
        return ret
      end,
      confirm = function(picker, item)
        picker:close()
        if item then
          open_or_focus(item.wt)
        end
      end,
    })
    return
  end

  -- Fallback when snacks.picker is unavailable.
  vim.ui.select(items, {
    prompt = "Claude Worktrees",
    format_item = function(item)
      local glyph = item_marker(item)
      return string.format("%s %s  %s", glyph, item.branch, vim.fn.fnamemodify(item.wt.path, ":~"))
    end,
  }, function(item)
    if item then
      open_or_focus(item.wt)
    end
  end)
end

---Jump to the most-recently-updated other worktree whose Claude has a pending edit.
function M.jump_to_pending()
  if not wez_available() then
    vim.notify("WezTerm CLI not available — run inside WezTerm to jump", vim.log.levels.WARN)
    return
  end
  local now = os.time()
  local best, best_t = nil, -1
  for path, st in pairs(read_statuses()) do
    if path ~= own_worktree and st.pending_diff and st.pane_id and is_live(st, now) then
      if (st.updated_at or 0) > best_t then
        best, best_t = st, st.updated_at or 0
      end
    end
  end
  if not best then
    vim.notify("No worktree Claude is currently waiting", vim.log.levels.INFO)
    return
  end
  wez_activate(best.pane_id)
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

local function bootstrap()
  vim.defer_fn(function()
    local connected, pending = claude_state()
    write_own_status(connected, pending)
    start_timer()
  end, 200)
end

function M.setup()
  vim.api.nvim_create_user_command("ClaudeWorktrees", function()
    M.pick()
  end, { desc = "Claude worktree cockpit" })
  vim.api.nvim_create_user_command("ClaudeWorktreeJump", function()
    M.jump_to_pending()
  end, { desc = "Jump to a worktree whose Claude is waiting" })

  own_worktree = detect_worktree()
  if not own_worktree then
    return -- not in a git repo; commands still exist but the daemon stays idle
  end
  own_file = status_file_for(own_worktree)
  own_branch = current_branch(own_worktree)

  if vim.v.vim_did_enter == 1 then
    bootstrap()
  else
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = bootstrap })
  end

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if timer then
        timer:stop()
        if not timer:is_closing() then
          timer:close()
        end
        timer = nil
      end
      if own_file then
        os.remove(own_file)
      end
    end,
  })
end

return M
