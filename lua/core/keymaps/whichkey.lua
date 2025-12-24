-- whichkey group configuration
local M = {}

M.spec = {
  { '<leader>f', group = '[F]ind', icon = '󰈞 ' },
  { '<leader>e', group = '[E]xplorer', icon = '󰙅 ' },
  { '<leader>b', group = '[B]uffers', icon = ' ' },
  { '<leader>g', group = '[G]it', icon = '󰊢 ' },
  { '<leader>l', group = '[L]SP', icon = ' ' },
  { '<leader>T', group = '[T]ests', icon = '󰙨 ' },
  { '<leader>t', group = '[T]erminal', icon = ' ' },
  { '<leader>u', group = '[U]ser Interface', icon = '󱍂 ' },
  { '<leader>w', group = '[W]indows', icon = ' ' },
}

return M
