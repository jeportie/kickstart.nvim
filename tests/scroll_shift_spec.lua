local api = vim.api
local fn = vim.fn

local function fill(buf, n, prefix)
  prefix = prefix or "L"
  local lines = {}
  for i = 1, n do table.insert(lines, string.format("%s line %04d padding padding", prefix, i)) end
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function snap(win)
  local info = fn.getwininfo(win)[1] or {}
  local view = api.nvim_win_call(win, fn.winsaveview) or {}
  return {
    topline = info.topline,
    botline = info.botline,
    leftcol = view.leftcol or 0,
    lnum = info.lnum,
  }
end

local function reset_state()
  vim.cmd("silent! %bwipeout!")
  vim.opt.splitright = true
  pcall(function() vim.o.mousemev = false end)
  vim.g.extmarks_events = nil
  package.loaded["scrolldbg.volt_shim"] = nil
  package.loaded["volt.events"] = nil
  package.loaded["volt.state"] = nil
end

describe("multi-window scroll isolation", function()
  local left_win, right_win, left_buf, right_buf

  before_each(function()
    reset_state()
    left_buf = api.nvim_get_current_buf()
    fill(left_buf, 200, "L")
    left_win = api.nvim_get_current_win()
    vim.cmd("vsplit")
    right_win = api.nvim_get_current_win()
    right_buf = api.nvim_create_buf(false, true)
    api.nvim_win_set_buf(right_win, right_buf)
    fill(right_buf, 200, "R")
    api.nvim_set_current_win(right_win)
    vim.cmd.normal({ args = { "gg" }, bang = true })
    api.nvim_set_current_win(left_win)
    vim.cmd.normal({ args = { "gg" }, bang = true })
  end)

  it("scrolling right split does not change left split topline", function()
    api.nvim_set_current_win(right_win)
    local before = snap(left_win)
    vim.cmd.normal({ args = { "30j" }, bang = true })
    vim.cmd("doautocmd WinScrolled")
    local after = snap(left_win)
    assert.equals(before.topline, after.topline)
    assert.equals(before.leftcol, after.leftcol)
  end)

  it("scrolling left split does not change right split topline", function()
    api.nvim_set_current_win(left_win)
    local before = snap(right_win)
    vim.cmd.normal({ args = { "30j" }, bang = true })
    vim.cmd("doautocmd WinScrolled")
    local after = snap(right_win)
    assert.equals(before.topline, after.topline)
  end)

  it("horizontal scroll on left does not change right leftcol", function()
    api.nvim_set_current_win(left_win)
    vim.wo[left_win].wrap = false
    vim.wo[right_win].wrap = false
    local before = snap(right_win)
    vim.cmd.normal({ args = { "20zl" }, bang = true })
    vim.cmd("doautocmd WinScrolled")
    local after = snap(right_win)
    assert.equals(before.leftcol, after.leftcol)
  end)
end)

describe("volt_shim lifecycle", function()
  before_each(function()
    reset_state()
  end)

  it("preload sets vim.g.extmarks_events guard", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    assert.is_true(vim.g.extmarks_events == true)
  end)

  it("safe_enable does not set vim.o.mousemev", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    shim.safe_enable()
    assert.is_false(vim.o.mousemev)
  end)

  it("preload replaces volt.events.enable with no-op", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    local volt_events = require("volt.events")
    volt_events.enable()
    assert.is_false(vim.o.mousemev)
  end)

  it("cleanup_buf removes id from volt.events.bufs", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    local volt_events = require("volt.events")
    local fake_buf = 9999
    table.insert(volt_events.bufs, fake_buf)
    shim.cleanup_buf(fake_buf)
    assert.is_false(vim.tbl_contains(volt_events.bufs, fake_buf))
  end)

  it("cleanup_buf clears volt.state[buf]", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    local volt_state = require("volt.state")
    local fake_buf = 9999
    volt_state[fake_buf] = { stale = true }
    shim.cleanup_buf(fake_buf)
    assert.is_nil(volt_state[fake_buf])
  end)

  it("cleanup_buf reverts mousemev when last buffer dies", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    local volt_events = require("volt.events")
    table.insert(volt_events.bufs, 9999)
    vim.o.mousemev = true
    shim.cleanup_buf(9999)
    assert.is_false(vim.o.mousemev)
  end)
end)

describe("regression: closing volt-managed buffer", function()
  before_each(function() reset_state() end)

  it("does not leave on_key handler hot for next session", function()
    local shim = require("scrolldbg.volt_shim")
    shim.preload()
    local volt_events = require("volt.events")
    local fake_buf = api.nvim_create_buf(false, true)
    table.insert(volt_events.bufs, fake_buf)
    shim.safe_enable()
    api.nvim_buf_delete(fake_buf, { force = true })
    shim.cleanup_buf(fake_buf)
    assert.is_false(vim.o.mousemev)
    assert.is_false(vim.tbl_contains(volt_events.bufs, fake_buf))
  end)
end)
