local M = {}

local probes = require("scrolldbg.probes")
local log = require("scrolldbg.log")

function M.start() probes.start() end
function M.stop() probes.stop() end
function M.report() probes.report() end
function M.snapshot() probes.snapshot_now() end
function M.reset() log.reset() end
function M.tail() vim.cmd("tabnew " .. vim.fn.fnameescape(log.path)) end

M.path = log.path

return M
