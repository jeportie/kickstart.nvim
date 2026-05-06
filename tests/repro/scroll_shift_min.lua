vim.opt.runtimepath:prepend(vim.fn.expand("~/.config/nvim"))
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/volt")

vim.opt.lines = 40
vim.opt.columns = 160

local api = vim.api
local fn = vim.fn

local function fill_buffer(buf, n)
  local lines = {}
  for i = 1, n do table.insert(lines, string.format("line %04d  some content padding here", i)) end
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function snapshot(win)
  if not api.nvim_win_is_valid(win) then
    error("snapshot: invalid window " .. tostring(win))
  end
  local info = fn.getwininfo(win)[1] or {}
  local view = api.nvim_win_call(win, fn.winsaveview) or {}
  local cursor = api.nvim_win_get_cursor(win)
  return {
    topline = info.topline or 0,
    botline = info.botline or 0,
    leftcol = view.leftcol or 0,
    lnum = info.lnum or cursor[1] or 0,
    cursor_col = cursor[2] or 0,
  }
end

local function fmt(s)
  return string.format("topline=%d botline=%d leftcol=%d lnum=%d col=%d",
    s.topline, s.botline, s.leftcol, s.lnum, s.cursor_col)
end

local fail_count = 0
local function expect(label, ok, detail)
  io.write(string.format("  %s %s", ok and "PASS" or "FAIL", label))
  if detail then io.write("  -- " .. detail) end
  io.write("\n")
  if not ok then fail_count = fail_count + 1 end
end

local function get_voltshim()
  local ok, mod = pcall(require, "scrolldbg.volt_shim")
  if ok then return mod end
  return nil
end

print("=== Scroll-shift reproduction harness ===")
print(string.format("Neovim %s", tostring(vim.version())))

local left_win = api.nvim_get_current_win()
local left_buf = api.nvim_get_current_buf()
fill_buffer(left_buf, 200)

vim.opt.splitright = true
vim.cmd("vsplit")
local right_win = api.nvim_get_current_win()
local right_buf = api.nvim_create_buf(false, true)
api.nvim_win_set_buf(right_win, right_buf)
fill_buffer(right_buf, 200)
assert(left_win ~= right_win, "split did not create a new window")

local mousemev_initial = vim.o.mousemev
local shim = get_voltshim()

print("")
print("Test 1: viewport isolation across vertical splits")
api.nvim_set_current_win(left_win)
vim.cmd.normal({ args = { "gg" }, bang = true })
api.nvim_set_current_win(right_win)
vim.cmd.normal({ args = { "gg" }, bang = true })
local left_before = snapshot(left_win)
vim.cmd.normal({ args = { "30j" }, bang = true })
vim.cmd("doautocmd WinScrolled")
local left_after = snapshot(left_win)
expect(
  "scrolling right split does not change left split topline",
  left_before.topline == left_after.topline,
  string.format("before=%s, after=%s", fmt(left_before), fmt(left_after))
)
expect(
  "scrolling right split does not change left split leftcol",
  left_before.leftcol == left_after.leftcol
)

print("")
print("Test 2: volt.events.enable does not leak global state")
local volt_events_ok, volt_events = pcall(require, "volt.events")
expect("volt.events module loads", volt_events_ok, tostring(volt_events))

if volt_events_ok then
  table.insert(volt_events.bufs, right_buf)
  if shim and shim.safe_enable then
    print("  using scrolldbg.volt_shim.safe_enable()")
    shim.safe_enable()
  else
    print("  using volt.events.enable() (no shim installed)")
    volt_events.enable()
  end
  expect(
    "volt.events handler is namespaced (revertible)",
    shim ~= nil,
    "shim provides namespace; raw volt.events does not"
  )
end

print("")
print("Test 3: cleanup restores global state")
if shim and shim.cleanup_buf then
  shim.cleanup_buf(right_buf)
  expect(
    "vim.o.mousemev restored after last volt buffer cleaned",
    vim.o.mousemev == mousemev_initial,
    string.format("expected=%s, got=%s", tostring(mousemev_initial), tostring(vim.o.mousemev))
  )
elseif volt_events_ok then
  expect(
    "vim.o.mousemev is reverted (without shim, this fails)",
    vim.o.mousemev == mousemev_initial,
    string.format("expected=%s, got=%s — root cause confirmed",
      tostring(mousemev_initial), tostring(vim.o.mousemev))
  )
end

print("")
if fail_count == 0 then
  print("ALL PASS")
  os.exit(0)
else
  print(string.format("%d FAILURE(S)", fail_count))
  os.exit(1)
end
