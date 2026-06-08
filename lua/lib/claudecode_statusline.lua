local M = {}

---Statusline module: shows a Claude indicator.
---  - hidden when the plugin hasn't been loaded yet (preserves lazy-load)
---  - dim icon when loaded but no active WebSocket connection
---  - bright icon when Claude CLI is connected to the in-editor MCP server
function M.claude()
  if not package.loaded["claudecode"] then
    return ""
  end
  local ok, claudecode = pcall(require, "claudecode")
  if not ok then
    return ""
  end
  local connected = claudecode.is_claude_connected and claudecode.is_claude_connected() or false
  if connected then
    return "%#St_LspMsg# ✻ "
  else
    return "%#St_Lsp# ✻ "
  end
end

return M