-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    preset = 'classic',
    delay = 10,
    icons = {
      mappings = true,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = {},
      function()
        dofile(vim.g.base46_cache .. 'whichkey')
        return {}
      end,
    },

    -- Document existing key chains
    spec = require('core.keymaps.whichkey').spec,
  },
}
