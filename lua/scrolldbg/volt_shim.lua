local M = {}

local api = vim.api

local NS_NAME = "scrolldbg_volt_shim"
local ns_id = nil
local installed = false
local original_enable = nil
local original_mousemev = nil

local function load_volt_events()
  local ok, mod = pcall(require, "volt.events")
  if ok then return mod end
  return nil
end

local function load_volt_state()
  local ok, mod = pcall(require, "volt.state")
  if ok then return mod end
  return nil
end

local function shim_enable_body()
  if vim.g.scrolldbg_disable_volt_shim then
    if original_enable then original_enable() end
    return
  end
end

function M.preload()
  if original_mousemev == nil then
    original_mousemev = vim.o.mousemev
  end
  vim.g.extmarks_events = true
  if ns_id == nil then
    ns_id = api.nvim_create_namespace(NS_NAME)
  end
  if installed then return end
  local volt_events = load_volt_events()
  if not volt_events then return end
  if original_enable == nil then
    original_enable = volt_events.enable
  end
  volt_events.enable = shim_enable_body
  installed = true
end

function M.safe_enable()
  M.preload()
  shim_enable_body()
end

function M.cleanup_buf(buf)
  if not buf then return end

  local volt_events = load_volt_events()
  if volt_events and volt_events.bufs then
    for i = #volt_events.bufs, 1, -1 do
      if volt_events.bufs[i] == buf then
        table.remove(volt_events.bufs, i)
      end
    end
  end

  local volt_state = load_volt_state()
  if volt_state then volt_state[buf] = nil end

  if volt_events and #(volt_events.bufs or {}) == 0 then
    M.full_revert()
  end
end

function M.full_revert()
  if ns_id then
    pcall(vim.on_key, nil, ns_id)
  end
  if original_mousemev ~= nil then
    pcall(function() vim.o.mousemev = original_mousemev end)
  end
end

function M.is_installed()
  return installed
end

return M
