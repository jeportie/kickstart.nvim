local M = {}

local state_file = vim.fn.stdpath("data") .. "/claudecode_resume.json"

-- Only gate the very first Claude open per nvim session.
local session_checked = false
local popup_open = false

local function read_state()
  local f = io.open(state_file, "r")
  if not f then
    return { dismissed = {} }
  end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then
    return { dismissed = {} }
  end
  data.dismissed = data.dismissed or {}
  return data
end

local function write_state(data)
  local f = io.open(state_file, "w")
  if not f then
    return
  end
  f:write(vim.json.encode(data))
  f:close()
end

local function encode_cwd(cwd)
  return (cwd:gsub("[./]", "-"))
end

local function has_sessions(cwd)
  local dir = vim.fn.expand("~/.claude/projects/") .. encode_cwd(cwd)
  if vim.fn.isdirectory(dir) ~= 1 then
    return false
  end
  return vim.fn.glob(dir .. "/*.jsonl") ~= ""
end

local function is_dismissed(cwd)
  return vim.tbl_contains(read_state().dismissed, cwd)
end

local function dismiss(cwd)
  local state = read_state()
  table.insert(state.dismissed, cwd)
  write_state(state)
end

---Show the resume popup.
---@param cwd string Current working directory
---@param on_resume function Called when the user chooses to resume
---@param on_fresh function Called when the user declines (open a fresh session)
local function show_popup(cwd, on_resume, on_fresh)
  local display = vim.fn.fnamemodify(cwd, ":~")
  local lines = {
    "",
    "  Resume last Claude session for",
    "  " .. display,
    "",
    "  [Y]es   [N]o   [X] never here",
    "",
  }
  local width = math.max(44, #display + 8)
  local height = #lines

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Resume Claude? ",
    title_pos = "center",
  })

  vim.wo[win].cursorline = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  popup_open = true

  local function close()
    popup_open = false
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local opts = { buffer = buf, nowait = true, silent = true }
  local map = vim.keymap.set

  local function yes()
    close()
    on_resume()
  end
  local function no()
    close()
    on_fresh()
  end
  local function never()
    close()
    dismiss(cwd)
    vim.notify("Claude resume disabled for " .. display, vim.log.levels.INFO)
    on_fresh()
  end

  map("n", "y", yes, opts)
  map("n", "Y", yes, opts)
  map("n", "<CR>", yes, opts)
  map("n", "n", no, opts)
  map("n", "N", no, opts)
  map("n", "<Esc>", no, opts)
  map("n", "q", no, opts)
  map("n", "x", never, opts)
  map("n", "X", never, opts)
end

---Toggle Claude, gating the first open of the session behind a resume prompt.
---Wire this to the Claude toggle keymaps in place of `:ClaudeCode`.
function M.toggle()
  -- Avoid re-entry while the popup is up.
  if popup_open then
    return
  end

  local function fresh()
    vim.cmd("ClaudeCode")
  end

  -- After the first decision this session, behave like a plain toggle.
  if session_checked then
    return fresh()
  end
  session_checked = true

  -- If Claude was already opened by some other path, just toggle.
  local term_ok, term = pcall(require, "claudecode.terminal")
  if term_ok and term.get_active_terminal_bufnr and term.get_active_terminal_bufnr() then
    return fresh()
  end

  local cwd = vim.fn.getcwd()
  if is_dismissed(cwd) or not has_sessions(cwd) then
    return fresh()
  end

  show_popup(cwd, function()
    vim.cmd("ClaudeCode --continue")
  end, fresh)
end

function M.setup()
  vim.api.nvim_create_user_command("ClaudeCodeResumeUndismiss", function()
    local cwd = vim.fn.getcwd()
    local state = read_state()
    local kept = {}
    for _, d in ipairs(state.dismissed) do
      if d ~= cwd then
        table.insert(kept, d)
      end
    end
    state.dismissed = kept
    write_state(state)
    vim.notify("Claude resume re-enabled for " .. cwd, vim.log.levels.INFO)
  end, { desc = "Re-enable Claude resume prompt for current cwd" })
end

return M