local M = {}

-- Lines whose first non-blank characters are this marker are treated as review
-- comments inside a Claude proposed-diff buffer. They are never written to disk
-- (denying discards the buffer), so the marker need not be a valid comment in
-- the target language -- it is only a sentinel for the scanner below.
local marker = "#>"

---Return the active-diff entry for a tab_name, if the plugin exposes it.
---@param tab_name string
---@return table|nil
local function active_diff(tab_name)
  local ok, diff = pcall(require, "claudecode.diff")
  if not ok or type(diff._get_active_diffs) ~= "function" then
    return nil
  end
  local diffs = diff._get_active_diffs()
  return diffs and diffs[tab_name] or nil
end

---Resolve a display path for the file under review.
---@param buf number Proposed buffer id
---@param tab_name string
---@return string|nil relpath Path relative to cwd, or nil if unknown
local function resolve_relpath(buf, tab_name)
  local entry = active_diff(tab_name)
  local path = entry and entry.old_file_path
  if not path or path == "" then
    -- Fall back to the proposed buffer's name, e.g. "<path> (proposed)".
    local name = vim.api.nvim_buf_get_name(buf)
    path = name:gsub("%s*%(.-%)%s*$", "")
  end
  if not path or path == "" then
    return nil
  end
  return vim.fn.fnamemodify(path, ":.")
end

---Guard: the current buffer must be a Claude proposed-diff buffer.
---@return number|nil buf, string|nil tab_name
local function require_diff_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local tab_name = vim.b[buf].claudecode_diff_tab_name
  if not tab_name then
    vim.notify("Not in a Claude proposed-diff buffer (focus the right side)", vim.log.levels.WARN)
    return nil, nil
  end
  return buf, tab_name
end

---Insert a `#> ` comment line below the current line and enter insert mode.
---The marker matches the current line's indentation so it reads in context.
function M.add_comment()
  local buf, _ = require_diff_buffer()
  if not buf then
    return
  end
  if not vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
    vim.notify("Proposed buffer is not modifiable", vim.log.levels.WARN)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1] -- 1-based current line
  local code_line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
  local indent = code_line:match("^%s*") or ""
  local text = indent .. marker .. " "

  vim.api.nvim_buf_set_lines(buf, row, row, false, { text }) -- insert below current line
  vim.api.nvim_win_set_cursor(win, { row + 1, 0 })
  vim.cmd("startinsert!") -- append at end of the new line
end

---Scan the proposed buffer, separating `#>` comments from code. Each comment is
---anchored to the nearest preceding code line (or the following one if it sits
---at the very top). Line numbers are computed against the *real* proposed
---content -- i.e. excluding the inserted comment lines -- so they stay correct.
---@param buf number
---@return table[] comments List of { lnum = number, snippet = string, text = string }
local function collect_comments(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local pat = "^%s*" .. vim.pesc(marker) .. "%s?(.*)$"

  local comments = {}
  local pending_above = {} -- comments seen before any code line yet
  local real_lnum = 0 -- line number within the proposed content (no comment lines)
  local last_code = nil -- { lnum, snippet } of the nearest preceding code line

  for _, line in ipairs(lines) do
    local note = line:match(pat)
    if note then
      note = note:gsub("%s+$", "")
      if last_code then
        table.insert(comments, { lnum = last_code.lnum, snippet = last_code.snippet, text = note })
      else
        table.insert(pending_above, note) -- anchor to the first code line we find
      end
    else
      real_lnum = real_lnum + 1
      local snippet = vim.trim(line)
      if #snippet > 80 then
        snippet = snippet:sub(1, 77) .. "..."
      end
      last_code = { lnum = real_lnum, snippet = snippet }
      for _, n in ipairs(pending_above) do
        table.insert(comments, { lnum = real_lnum, snippet = snippet, text = n })
      end
      pending_above = {}
    end
  end

  -- Only reached if the buffer contained no code lines at all.
  for _, n in ipairs(pending_above) do
    table.insert(comments, { lnum = 0, snippet = "", text = n })
  end

  return comments
end

---Deny the current diff and send all `#>` comments to Claude as revision notes.
---Falls back to a plain deny (with a notice) when no comments are present.
function M.deny_with_comments()
  local buf, tab_name = require_diff_buffer()
  if not buf then
    return
  end

  local comments = collect_comments(buf)
  local relpath = resolve_relpath(buf, tab_name)

  local function deny()
    pcall(function()
      require("claudecode.diff").deny_current_diff()
    end)
  end

  if #comments == 0 then
    vim.notify("No " .. marker .. " comments found -- denying without feedback", vim.log.levels.INFO)
    deny()
    return
  end

  local header
  if relpath then
    header = "I reviewed your proposed changes to `" .. relpath .. "` and rejected the diff."
  else
    header = "I reviewed your proposed changes and rejected the diff."
  end
  local out = { header, "Please revise and re-apply, addressing these review comments:", "" }
  for _, c in ipairs(comments) do
    if c.lnum > 0 and c.snippet ~= "" then
      table.insert(out, string.format("- L%d (near `%s`): %s", c.lnum, c.snippet, c.text))
    else
      table.insert(out, string.format("- %s", c.text))
    end
  end
  table.insert(out, "")
  table.insert(out, "Re-apply the edit so it addresses every comment above.")
  local message = table.concat(out, "\n")

  -- Reject first (same path as <leader>ad), then send feedback once the
  -- DIFF_REJECTED response has flushed and any diff tab has closed.
  deny()
  vim.defer_fn(function()
    local ok, extras = pcall(require, "lib.claudecode_extras")
    if ok then
      extras.send_text(message .. "\n")
    end
  end, 150)
end

---Resolve the diff under the cursor with a single keystroke: accept when there
---are no `#>` comments, otherwise deny and send the comments as feedback.
---Bound to <CR> (normal mode) inside proposed-diff buffers by M.setup().
function M.smart_resolve()
  local buf = require_diff_buffer()
  if not buf then
    return
  end
  if #collect_comments(buf) == 0 then
    pcall(function()
      require("claudecode.diff").accept_current_diff()
    end)
  else
    M.deny_with_comments()
  end
end

---True if a buffer is a Claude proposed-diff buffer (named "... (proposed)" or
---"... (NEW FILE - proposed)").
local function is_proposed_buffer(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  return name:match("%(proposed%)$") ~= nil or name:match("%(NEW FILE %- proposed%)$") ~= nil
end

---Install the smart <CR> mapping on Claude proposed-diff buffers as they open.
---Idempotent; also maps any proposed buffer already open, so it works when
---called mid-diff (e.g. after a live reload).
function M.setup()
  local function install(buf)
    vim.keymap.set("n", "<CR>", function()
      require("lib.claudecode_review").smart_resolve()
    end, { buffer = buf, nowait = true, silent = true, desc = "Resolve Claude diff (accept / deny + notes)" })
  end

  local grp = vim.api.nvim_create_augroup("ClaudeCodeReviewEnter", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    group = grp,
    callback = function(args)
      if is_proposed_buffer(args.buf) then
        install(args.buf)
      end
    end,
  })

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and is_proposed_buffer(b) then
      install(b)
    end
  end
end

return M