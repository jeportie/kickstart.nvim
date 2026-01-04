return {
  'nvzone/menu',
  lazy = false,

  config = function()
    -- ------------------------------------------------------------
    -- Define Lazy menu as a virtual module
    -- ------------------------------------------------------------
    package.preload['menus.lazy'] = function()
      return {
        {
          name = 'Lazy.nvim',
          hl = 'Title',
        },

        { name = 'Sync plugins',     cmd = 'Lazy sync',    rtxt = 's' },
        { name = 'Update plugins',   cmd = 'Lazy update',  rtxt = 'u' },
        { name = 'Clean plugins',    cmd = 'Lazy clean',   rtxt = 'c' },
        { name = 'Check plugins',    cmd = 'Lazy check',   rtxt = 'k' },
        { name = 'Profile startup',  cmd = 'Lazy profile', rtxt = 'p' },

        { name = '',                 cmd = '' }, -- separator MUST have name

        { name = 'Restore lockfile', cmd = 'Lazy restore', rtxt = 'r' },
        { name = 'Home',             cmd = 'Lazy home',    rtxt = 'h' },
        { name = 'Quit Lazy',        cmd = 'q',            rtxt = 'q' },
      }
    end
  end,

  keys = {
    {
      '<C-t>',
      function()
        require('menu').open 'default'
      end,
      desc = 'Open menu (keyboard)',
    },

    {
      '<RightMouse>',
      function()
        local menu = require 'menu'
        require('menu.utils').delete_old_menus()
        vim.cmd.exec '"normal! \\<RightMouse>"'

        local winid = vim.fn.getmousepos().winid
        if not winid or winid == 0 then
          menu.open('default', { mouse = true })
          return
        end

        local buf = vim.api.nvim_win_get_buf(winid)
        local ft = vim.bo[buf].filetype

        local target
        if ft == 'NvimTree' or ft == 'neo-tree' or ft:match('neo%-tree') then
          target = 'nvimtree'
        elseif ft == 'lazy' then
          target = 'lazy'
        else
          target = 'default'
        end

        menu.open(target, { mouse = true })
      end,
      desc = 'Open context menu (mouse)',
    },
  },
}
