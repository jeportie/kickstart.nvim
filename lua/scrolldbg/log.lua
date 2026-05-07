local M = {}

local fn = vim.fn
local uv = vim.uv or vim.loop

M.path = fn.stdpath("cache") .. "/scrolldbg.jsonl"

local fd = nil

local function ensure_open()
  if fd then return fd end
  fn.mkdir(fn.stdpath("cache"), "p")
  fd = uv.fs_open(M.path, "a", 420)
  return fd
end

function M.write(record)
  if not fd then ensure_open() end
  if not fd then return end
  record.ts = os.time()
  record.hr = uv.hrtime()
  local ok, line = pcall(vim.json.encode, record)
  if not ok then
    local fallback = vim.json.encode({
      event = "encode_error",
      original_event = tostring(record.event),
      error = tostring(line),
      ts = record.ts,
    })
    uv.fs_write(fd, fallback .. "\n", -1)
    return
  end
  uv.fs_write(fd, line .. "\n", -1)
end

function M.close()
  if fd then
    uv.fs_close(fd)
    fd = nil
  end
end

function M.reset()
  M.close()
  pcall(uv.fs_unlink, M.path)
end

function M.read_all()
  M.close()
  local lines = {}
  local f = io.open(M.path, "r")
  if not f then return lines end
  for line in f:lines() do
    local ok, rec = pcall(vim.json.decode, line)
    if ok then table.insert(lines, rec) end
  end
  f:close()
  return lines
end

return M
