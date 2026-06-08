local M = {}

local function get_term_chan()
  local ok, term = pcall(require, "claudecode.terminal")
  if not ok then
    return nil
  end
  local bufnr = term.get_active_terminal_bufnr and term.get_active_terminal_bufnr()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end
  local chan = vim.bo[bufnr].channel
  if not chan or chan == 0 then
    return nil
  end
  return chan
end

---Send a message to the Claude terminal as if typed by the user, then submit it.
---
---Submission uses a carriage return (`\r`) -- a TUI's Enter is `\r`, not `\n` --
---and the text is wrapped in bracketed paste (`<ESC>[200~ ... <ESC>[201~`) so a
---multi-line message is inserted as one block instead of submitting line-by-line.
---Opens Claude if it isn't running yet.
---@param text string The message to send (any trailing newline is ignored)
function M.send_text(text)
  -- We submit explicitly below, so drop any trailing newline the caller added.
  text = (text or ""):gsub("[\r\n]+$", "")

  local function write(chan)
    vim.api.nvim_chan_send(chan, "\27[200~" .. text .. "\27[201~\r")
    -- Surface the terminal (without stealing focus) so the reply is visible.
    pcall(function()
      require("claudecode.terminal").ensure_visible()
    end)
  end

  local chan = get_term_chan()
  if chan then
    write(chan)
    return
  end

  -- Open Claude, then write once the terminal is ready.
  vim.cmd("ClaudeCode")
  local attempts = 0
  local timer = vim.uv.new_timer()
  timer:start(150, 150, vim.schedule_wrap(function()
    attempts = attempts + 1
    local c = get_term_chan()
    if c then
      write(c)
      timer:stop()
      timer:close()
    elseif attempts >= 20 then
      timer:stop()
      timer:close()
      vim.notify("Claude terminal channel did not become ready", vim.log.levels.WARN)
    end
  end))
end

---Send the current buffer's LSP diagnostics with a "please fix" prompt.
function M.send_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end

  local relpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local sev_names = { "ERROR", "WARN", "INFO", "HINT" }
  local lines = { string.format("Please fix the diagnostics in @%s:", relpath) }
  for _, d in ipairs(diagnostics) do
    local sev = sev_names[d.severity] or "INFO"
    table.insert(lines, string.format("  L%d: [%s] %s", d.lnum + 1, sev, d.message))
  end
  M.send_text(table.concat(lines, "\n"))
end

---Walk up the treesitter tree from the cursor to find the enclosing function,
---then send it as an @mention with line range.
function M.send_enclosing_function()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    vim.notify("No treesitter node at cursor", vim.log.levels.WARN)
    return
  end

  local function_types = {
    function_declaration = true,
    function_definition = true,
    function_item = true,
    method_definition = true,
    method_declaration = true,
    arrow_function = true,
    local_function = true,
    lambda = true,
  }

  local target = node
  while target do
    if function_types[target:type()] then
      break
    end
    target = target:parent()
  end

  if not target then
    vim.notify("No enclosing function found", vim.log.levels.INFO)
    return
  end

  local start_row, _, end_row, _ = target:range()
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    vim.notify("Buffer has no file path", vim.log.levels.WARN)
    return
  end

  local cc_ok, claudecode = pcall(require, "claudecode")
  if not cc_ok or not claudecode.send_at_mention then
    vim.notify("claudecode.send_at_mention not available", vim.log.levels.ERROR)
    return
  end
  claudecode.send_at_mention(fname, start_row, end_row, "function")
end

---Capture `git diff` (working tree) and send it for review.
function M.send_git_diff()
  local diff = vim.fn.system("git diff")
  if vim.v.shell_error ~= 0 then
    vim.notify("git diff failed: " .. diff, vim.log.levels.ERROR)
    return
  end
  if diff == "" then
    vim.notify("No git diff (working tree clean)", vim.log.levels.INFO)
    return
  end
  if #diff > 200000 then
    vim.notify(string.format("Diff is %d chars — sending anyway, but consider narrowing", #diff), vim.log.levels.WARN)
  end
  local prompt = "Please review my changes:\n\n```diff\n" .. diff .. "\n```\n"
  M.send_text(prompt)
end

---Send a slash command (e.g. "review", "test") followed by Enter so Claude executes it.
---@param cmd string The slash command without the leading slash
function M.send_slash(cmd)
  M.send_text("/" .. cmd .. "\n")
end

return M