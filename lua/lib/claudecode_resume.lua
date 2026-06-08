local M = {}

local state_file = vim.fn.stdpath("data") .. "/claudecode_resume.json"

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

local function show_popup(cwd)
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

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local opts = { buffer = buf, nowait = true, silent = true }
  local map = vim.keymap.set

  local function yes()
    close()
    vim.cmd("ClaudeCode --continue")
  end
  local function no()
    close()
  end
  local function never()
    close()
    dismiss(cwd)
    vim.notify("Claude resume disabled for " .. display, vim.log.levels.INFO)
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

function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(function()
        local cwd = vim.fn.getcwd()
        if is_dismissed(cwd) then
          return
        end
        if not has_sessions(cwd) then
          return
        end
        show_popup(cwd)
      end, 80)
    end,
  })

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
