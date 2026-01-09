local M = {}

-- Omarchy exposes this path consistently
M.is_omarchy = vim.fn.isdirectory("/home/jeportie/.config/omarchy") == 1

return M
