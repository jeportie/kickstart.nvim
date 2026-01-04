return {
  'nvim-lua/plenary.nvim',
  {
    'nvim-tree/nvim-web-devicons',
    opts = function()
      -- define your override table inline, including the CSS icon
      local icons = {
        default_icon = { icon = '󰈚', name = 'Default' },
        js = { icon = '󰌞', name = 'js' },
        ts = { icon = '󰛦', name = 'ts' },
        lock = { icon = '󰌾', name = 'lock' },
        ['robots.txt'] = { icon = '󰚩', name = 'robots' },
        css = { icon = '', name = 'css', color = '#1572B6' },
        -- you can keep adding other overrides here...
      }

      return { override = icons }
    end,
  },
  {
    'nvchad/ui',
    lazy = false,
  },
  {
    'nvchad/base46',
    build = function()
      require('base46').load_all_highlights()
    end,
  },
  'nvchad/volt',
}
