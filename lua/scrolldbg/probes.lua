local M = {}

local api = vim.api
local snapshot = require("scrolldbg.snapshot")
local log = require("scrolldbg.log")

M.active = false

local prev_state = nil
local group = nil
local original_on_key = vim.on_key

local TRACKED_OPTIONS = {
  "signcolumn", "numberwidth", "foldcolumn", "statuscolumn",
  "scrolloff", "sidescrolloff",
  "scrollbind", "cursorbind",
  "wrap", "virtualedit",
  "mousemev", "mouse",
}

local function record_event(kind, extra)
  local cur = snapshot.all()
  local diffs = prev_state and snapshot.diff(prev_state, cur) or {}
  prev_state = cur
  local rec = { event = kind, diffs = diffs, current_win = api.nvim_get_current_win() }
  if extra then
    for k, v in pairs(extra) do rec[k] = v end
  end
  log.write(rec)
end

function M.start()
  if M.active then return end
  M.active = true
  prev_state = snapshot.all()
  group = api.nvim_create_augroup("scrolldbg", { clear = true })

  api.nvim_create_autocmd("WinScrolled", {
    group = group,
    callback = function(args) record_event("WinScrolled", { match = args.match }) end,
  })

  api.nvim_create_autocmd("WinResized", {
    group = group,
    callback = function(args) record_event("WinResized", { match = args.match }) end,
  })

  api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function() record_event("CursorMoved") end,
  })

  for _, opt in ipairs(TRACKED_OPTIONS) do
    api.nvim_create_autocmd("OptionSet", {
      group = group,
      pattern = opt,
      callback = function()
        log.write({
          event = "OptionSet",
          option = opt,
          new = tostring(vim.v.option_new),
          old = tostring(vim.v.option_old),
          scope = vim.v.option_type,
          traceback = debug.traceback("", 2),
        })
      end,
    })
  end

  if vim.on_key ~= M._wrapped_on_key then
    vim.on_key = function(fn_, ns_id)
      log.write({
        event = "on_key_register",
        ns_id = ns_id,
        has_callback = fn_ ~= nil,
        traceback = debug.traceback("", 2),
      })
      return original_on_key(fn_, ns_id)
    end
    M._wrapped_on_key = vim.on_key
  end

  log.write({ event = "start", initial = prev_state })
end

function M.stop()
  if not M.active then return end
  M.active = false
  if group then
    api.nvim_del_augroup_by_id(group)
    group = nil
  end
  vim.on_key = original_on_key
  M._wrapped_on_key = nil
  log.write({ event = "stop" })
  log.close()
end

function M.snapshot_now()
  log.write({ event = "snapshot_manual", state = snapshot.all() })
end

function M.report()
  local recs = log.read_all()
  if #recs == 0 then
    vim.notify("scrolldbg: no log at " .. log.path, vim.log.levels.WARN)
    return
  end

  local counts = { WinScrolled = 0, WinResized = 0, OptionSet = 0, on_key_register = 0, CursorMoved = 0 }
  local opt_changes = {}
  local on_key_tracebacks = {}
  local shifts_with_inactive_changes = 0

  for _, rec in ipairs(recs) do
    if counts[rec.event] ~= nil then counts[rec.event] = counts[rec.event] + 1 end
    if rec.event == "OptionSet" then
      table.insert(opt_changes, string.format("  %s = %s (was %s, scope=%s)",
        rec.option, rec.new, rec.old, rec.scope))
    elseif rec.event == "on_key_register" then
      table.insert(on_key_tracebacks, rec.traceback)
    elseif rec.event == "WinScrolled" and rec.diffs then
      local cur = rec.current_win
      for _, d in ipairs(rec.diffs) do
        if d.win ~= cur and d.changes and (d.changes.topline or d.changes.leftcol) then
          shifts_with_inactive_changes = shifts_with_inactive_changes + 1
          break
        end
      end
    end
  end

  local out = {
    "scrolldbg report — " .. log.path,
    string.format("  Total records:               %d", #recs),
    string.format("  WinScrolled events:          %d", counts.WinScrolled),
    string.format("    └─ with inactive shifts:   %d  ← bug indicator", shifts_with_inactive_changes),
    string.format("  WinResized events:           %d", counts.WinResized),
    string.format("  CursorMoved events:          %d", counts.CursorMoved),
    string.format("  OptionSet events:            %d", counts.OptionSet),
    string.format("  on_key registrations:        %d", counts.on_key_register),
  }
  if #opt_changes > 0 then
    table.insert(out, "")
    table.insert(out, "Option changes during capture:")
    for _, line in ipairs(opt_changes) do table.insert(out, line) end
  end
  if #on_key_tracebacks > 0 then
    table.insert(out, "")
    table.insert(out, "vim.on_key registration tracebacks:")
    for i, tb in ipairs(on_key_tracebacks) do
      table.insert(out, string.format("[%d] %s", i, tb))
    end
  end
  vim.notify(table.concat(out, "\n"), vim.log.levels.INFO)
end

return M
