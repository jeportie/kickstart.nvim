local M = {}

local api = vim.api
local fn = vim.fn

function M.window(win)
  if not api.nvim_win_is_valid(win) then return nil end
  local info = fn.getwininfo(win)[1] or {}
  local buf = api.nvim_win_get_buf(win)
  local cursor = api.nvim_win_get_cursor(win)
  local view = api.nvim_win_call(win, fn.winsaveview)
  return {
    win = win,
    buf = buf,
    name = api.nvim_buf_get_name(buf),
    ft = vim.bo[buf].filetype,
    topline = info.topline,
    botline = info.botline,
    leftcol = view.leftcol,
    skipcol = view.skipcol,
    lnum = cursor[1],
    col = cursor[2],
    signcolumn = vim.wo[win].signcolumn,
    foldcolumn = vim.wo[win].foldcolumn,
    numberwidth = vim.wo[win].numberwidth,
    statuscolumn = vim.wo[win].statuscolumn,
    wrap = vim.wo[win].wrap,
    scrollbind = vim.wo[win].scrollbind,
    cursorbind = vim.wo[win].cursorbind,
    scrolloff = vim.wo[win].scrolloff,
    sidescrolloff = vim.wo[win].sidescrolloff,
    virtualedit = vim.wo[win].virtualedit,
  }
end

function M.all()
  local out = {}
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    local s = M.window(win)
    if s then table.insert(out, s) end
  end
  return out
end

local function index_by_win(list)
  local idx = {}
  for _, s in ipairs(list) do idx[s.win] = s end
  return idx
end

function M.diff(prev, cur)
  local prev_idx = index_by_win(prev)
  local cur_idx = index_by_win(cur)
  local diffs = {}
  for win, s2 in pairs(cur_idx) do
    local s1 = prev_idx[win]
    if s1 then
      local changes = {}
      for k, v2 in pairs(s2) do
        local v1 = s1[k]
        if v1 ~= v2 then
          changes[k] = { from = v1, to = v2 }
        end
      end
      if next(changes) then
        table.insert(diffs, { win = win, buf = s2.buf, name = s2.name, changes = changes })
      end
    else
      table.insert(diffs, { win = win, buf = s2.buf, name = s2.name, changes = { _new_window = true } })
    end
  end
  for win, s1 in pairs(prev_idx) do
    if not cur_idx[win] then
      table.insert(diffs, { win = win, buf = s1.buf, name = s1.name, changes = { _closed = true } })
    end
  end
  return diffs
end

return M
