local M = {}

local pushed_this_session = false

---Build a one-line summary of active LSP clients for the current buffer.
---@return string|nil context Formatted context, or nil if no LSPs are attached
function M.get_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return nil
  end

  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end

  local ft = vim.bo[bufnr].filetype
  local lines = { string.format("Active LSPs for this %s buffer: %s", ft, table.concat(names, ", ")) }

  local root = clients[1].config and clients[1].config.root_dir
  if root and root ~= "" then
    table.insert(lines, "LSP root: " .. vim.fn.fnamemodify(root, ":~"))
  end

  return table.concat(lines, "\n") .. "\n"
end

---Send the LSP context to the Claude terminal. No-op if no LSPs.
function M.send_context()
  local ctx = M.get_context()
  if not ctx then
    vim.notify("No active LSP clients for current buffer", vim.log.levels.INFO)
    return
  end
  local ok, extras = pcall(require, "lib.claudecode_extras")
  if not ok then
    return
  end
  extras.send_text(ctx)
end

function M.setup()
  local grp = vim.api.nvim_create_augroup("ClaudeCodeLspFirstPush", { clear = true })
  vim.api.nvim_create_autocmd("TermOpen", {
    group = grp,
    callback = function(args)
      if pushed_this_session then
        return
      end
      local name = vim.api.nvim_buf_get_name(args.buf)
      if not name:lower():match("claude") then
        return
      end
      pushed_this_session = true
      -- Give Claude a moment to spawn its REPL before writing
      vim.defer_fn(function()
        pcall(M.send_context)
      end, 1500)
    end,
  })
end

return M
